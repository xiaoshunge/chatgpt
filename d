package com.yy.sdk.lbs;

import android.content.Context;
import android.os.Handler;
import android.text.TextUtils;
import com.yy.huanju.outlets.YYTimeouts;
import com.yy.sdk.protocol.DataSource;
import com.yy.sdk.protocol.EnsureSender;
import com.yy.sdk.protocol.UriDataHandler;
import com.yy.sdk.protocol.WrapUriDataHandler;
import com.yy.sdk.stat.PClientCallStaticPkg;
import com.yy.sdk.util.Log;
import com.yy.sdk.util.YYDebug;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.InetAddress;
import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Random;

/* loaded from: classes.dex */
public class LbsLinkManager implements DataSource, UriDataHandler {
    private static final String ET_LBS_SERVER_ADDR = "mobtestlbs.yy.duowan.com";
    private static final String ET_WT_LBS_SERVER_ADDR = "mobtestlbs.yy.duowan.com";
    private static final String HARDCODE_PRE_PUBLISH_HK_LBS_SERVER_ADDR = "175.100.204.138";
    private static final String HARDCODE_PRE_PUBLISH_LBS_SERVER_ADDR = "122.225.38.226";
    private static final String HARDCODE_PRE_PUBLISH_WT_LBS_SERVER_ADDR = "119.167.206.135";
    private static final String HK_LBS_NAME = "HK_LBS";
    private static final String LBS_IDX_KEY = "lbsIndex";
    public static final int LBS_INDEX = 1;
    private static final String LBS_NAME = "LBS";
    private static final String PREF_NAME = "lbsIndex";
    private static final String PRE_PUBLISH_HK_LBS_SERVER_ADDR = "hkhmmoblbs.yy.duowan.com";
    private static final String PRE_PUBLISH_LBS_SERVER_ADDR = "hmmoblbs.yy.duowan.com";
    private static final String PRE_PUBLISH_WT_LBS_SERVER_ADDR = "wthmmoblbs.yy.duowan.com";
    private static final String WT_LBS_NAME = "WT_LBS";
    private Handler mCallHandler;
    private int mCompareSeq;
    private OnLbsLinkConnectListener mConnectListener;
    private Context mContext;
    private boolean mIsConnecting;
    private static final short[] ET_LBS_PORTS = {14001, 15001, 16001, PClientCallStaticPkg.CALL_STAT_CALLED_PRESS_ACCEPT_OR_REJECT};
    private static final short[] PRE_PUBLISH_LBS_PORTS = {24001, 25001, 26001, 220};
    private static final short[] HARDCODE_PRE_PUBLISH_LBS_PORTS = {24001, 25001, 26001, 220};
    private static int LBS_CONN_MAX_LIMIT = 3;
    private String LBS_ADDR = PRE_PUBLISH_LBS_SERVER_ADDR;
    private String WT_LBS_ADDR = PRE_PUBLISH_WT_LBS_SERVER_ADDR;
    private String HK_LBS_ADDR = PRE_PUBLISH_HK_LBS_SERVER_ADDR;
    private short[] PORTS = PRE_PUBLISH_LBS_PORTS;
    private int DNS_FAIL_THRES = 3;
    private ArrayList<LbsLink> mConnectingLinks = new ArrayList<>();
    private LbsLink mSelectedLink = null;
    private Object mSelectedLinkSync = new Object();
    private Runnable mTimeoutTask = new Runnable() { // from class: com.yy.sdk.lbs.LbsLinkManager.4
        @Override // java.lang.Runnable
        public void run() {
            LbsLinkManager.this.reportConnectResult(false);
        }
    };
    private HashMap<Integer, ArrayList<UriDataHandler>> mHandlers = new HashMap<>();
    private EnsureSender mEnsureSender = new EnsureSender(this);

    /* JADX INFO: Access modifiers changed from: package-private */
    /* loaded from: classes.dex */
    public interface GetLbsAddrsListener {
        void onGetFailed(int i);

        void onGetSuccess(int i, ArrayList<InetAddress> arrayList);
    }

    /* loaded from: classes.dex */
    public interface OnLbsLinkConnectListener {
        void onLbsLinkConnect(boolean z);
    }

    public LbsLinkManager(Context context, OnLbsLinkConnectListener listener) {
        this.mContext = context;
        this.mConnectListener = listener;
        setLbsAddr(this.mContext.getSharedPreferences("lbsIndex", 0).getInt("lbsIndex", 1));
    }

    private void setLbsAddr(int idx) {
        if (idx == 1) {
            this.LBS_ADDR = PRE_PUBLISH_LBS_SERVER_ADDR;
            this.WT_LBS_ADDR = PRE_PUBLISH_WT_LBS_SERVER_ADDR;
            this.HK_LBS_ADDR = PRE_PUBLISH_HK_LBS_SERVER_ADDR;
            this.PORTS = PRE_PUBLISH_LBS_PORTS;
            this.DNS_FAIL_THRES = 3;
        } else if (idx == 2) {
            this.LBS_ADDR = "mobtestlbs.yy.duowan.com";
            this.WT_LBS_ADDR = "mobtestlbs.yy.duowan.com";
            this.HK_LBS_ADDR = null;
            this.PORTS = ET_LBS_PORTS;
            this.DNS_FAIL_THRES = 2;
        } else {
            this.LBS_ADDR = PRE_PUBLISH_LBS_SERVER_ADDR;
            this.WT_LBS_ADDR = PRE_PUBLISH_WT_LBS_SERVER_ADDR;
            this.HK_LBS_ADDR = PRE_PUBLISH_HK_LBS_SERVER_ADDR;
            this.PORTS = PRE_PUBLISH_LBS_PORTS;
            this.DNS_FAIL_THRES = 3;
        }
    }

    public void selectLbs(int idx) {
        Log.i("yysdk-lbs", "LbsLinkdManager.selectLbs: " + idx);
        setLbsAddr(idx);
        this.mContext.getSharedPreferences("lbsIndex", 0).edit().putInt("lbsIndex", idx).commit();
        clearLinks();
        clearAddrs(LBS_NAME);
        clearAddrs(WT_LBS_NAME);
        clearAddrs(HK_LBS_NAME);
    }

    public boolean checkLinkExist() {
        synchronized (this.mSelectedLinkSync) {
            if (this.mSelectedLink != null) {
                return true;
            }
            return false;
        }
    }

    public void clearLinks() {
        synchronized (this.mSelectedLinkSync) {
            if (this.mSelectedLink != null) {
                this.mSelectedLink.closeLink();
            }
            this.mSelectedLink = null;
        }
        synchronized (this.mConnectingLinks) {
            if (this.mConnectingLinks != null) {
                Iterator i$ = this.mConnectingLinks.iterator();
                while (i$.hasNext()) {
                    LbsLink link = i$.next();
                    if (link != null) {
                        link.closeLink();
                    }
                }
                this.mConnectingLinks.clear();
            }
        }
        this.mEnsureSender.reset();
    }

    /* JADX INFO: Access modifiers changed from: private */
    public ArrayList<InetAddress> loadAddrs(String name) {
        try {
            FileInputStream ins = this.mContext.openFileInput(name);
            byte[] data = new byte[(int) new File(this.mContext.getFilesDir(), name).length()];
            ins.read(data);
            ins.close();
            ByteArrayInputStream in = new ByteArrayInputStream(data);
            ObjectInputStream objIn = new ObjectInputStream(in);
            ArrayList<InetAddress> ret = (ArrayList) objIn.readObject();
            objIn.close();
            in.close();
            Log.d("yysdk-lbs", "LbsLinkdManager.loadAddr success: " + name);
            return ret;
        } catch (IOException e) {
            Log.d("yysdk-lbs", "LbsLinkdManager.loadAddrs not found when loading");
            return null;
        } catch (ClassNotFoundException e2) {
            Log.d("yysdk-lbs", "LbsLinkdManager.loadAddrs class error when loading");
            return null;
        }
    }

    /* JADX INFO: Access modifiers changed from: private */
    public boolean saveAddrs(String name, ArrayList<InetAddress> addrs) {
        if (addrs == null || addrs.isEmpty()) {
            clearAddrs(name);
            return true;
        }
        try {
            ByteArrayOutputStream out = new ByteArrayOutputStream();
            ObjectOutputStream objOut = new ObjectOutputStream(out);
            objOut.writeObject(addrs);
            byte[] data = out.toByteArray();
            objOut.close();
            out.close();
            FileOutputStream outs = this.mContext.openFileOutput(name, 0);
            outs.write(data);
            outs.close();
            Log.d("yysdk-lbs", "LbsLinkdManager.saveAddrs success: " + name + ", count=" + addrs.size());
            return true;
        } catch (Exception e) {
            Log.d("yysdk-lbs", "LbsLinkdManager.saveAddrs not found when saving");
            return false;
        }
    }

    private void clearAddrs(String name) {
        new File(this.mContext.getFilesDir(), name).delete();
        Log.d("yysdk-lbs", "LbsLinkdManager.clearAddrs: " + name);
    }

    /* JADX WARN: Type inference failed for: r0v0, types: [com.yy.sdk.lbs.LbsLinkManager$1] */
    /* JADX WARN: Type inference failed for: r0v1, types: [com.yy.sdk.lbs.LbsLinkManager$2] */
    /* JADX WARN: Type inference failed for: r0v4, types: [com.yy.sdk.lbs.LbsLinkManager$3] */
    private void getLBSAddrs(final int seq, final boolean hardcodeIp, final GetLbsAddrsListener l) {
        new Thread() { // from class: com.yy.sdk.lbs.LbsLinkManager.1
            @Override // java.lang.Thread, java.lang.Runnable
            public void run() {
                Log.d("yysdk-lbs", "LbsLinkdManager.start getLBSAddrs: seq=" + seq + " hardcodeIp=" + hardcodeIp);
                final ArrayList<InetAddress> addrs = null;
                if (hardcodeIp) {
                    InetAddress[] lbsAddrs = null;
                    try {
                        Log.d("yysdk-lbs", "LbsLinkdManager.start resolve:122.225.38.226");
                        lbsAddrs = InetAddress.getAllByName(LbsLinkManager.HARDCODE_PRE_PUBLISH_LBS_SERVER_ADDR);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                    if (lbsAddrs != null) {
                        addrs = new ArrayList<>();
                        for (int i = 0; i < lbsAddrs.length && i < 3; i++) {
                            addrs.add(lbsAddrs[i]);
                        }
                    }
                } else {
                    addrs = LbsLinkManager.this.loadAddrs(LbsLinkManager.LBS_NAME);
                    if (addrs == null) {
                        InetAddress[] lbsAddrs2 = null;
                        try {
                            Log.d("yysdk-lbs", "LbsLinkdManager.start resolve:" + LbsLinkManager.this.LBS_ADDR);
                            lbsAddrs2 = InetAddress.getAllByName(LbsLinkManager.this.LBS_ADDR);
                        } catch (Exception e2) {
                            e2.printStackTrace();
                        }
                        if (lbsAddrs2 != null) {
                            addrs = new ArrayList<>();
                            for (int i2 = 0; i2 < lbsAddrs2.length && i2 < 3; i2++) {
                                addrs.add(lbsAddrs2[i2]);
                            }
                            if (!addrs.isEmpty()) {
                                LbsLinkManager.this.saveAddrs(LbsLinkManager.LBS_NAME, addrs);
                            }
                        }
                    }
                }
                if (addrs == null || addrs.isEmpty()) {
                    Log.d("yysdk-lbs", "LbsLinkdManager.getLBSAddrs failed: seq=" + seq);
                    LbsLinkManager.this.mCallHandler.post(new Runnable() { // from class: com.yy.sdk.lbs.LbsLinkManager.1.1
                        @Override // java.lang.Runnable
                        public void run() {
                            l.onGetFailed(seq);
                        }
                    });
                    return;
                }
                Log.d("yysdk-lbs", "LbsLinkdManager.getLBSAddrs success: seq=" + seq);
                LbsLinkManager.this.mCallHandler.post(new Runnable() { // from class: com.yy.sdk.lbs.LbsLinkManager.1.2
                    @Override // java.lang.Runnable
                    public void run() {
                        l.onGetSuccess(seq, addrs);
                    }
                });
            }
        }.start();
        new Thread() { // from class: com.yy.sdk.lbs.LbsLinkManager.2
            @Override // java.lang.Thread, java.lang.Runnable
            public void run() {
                Log.d("yysdk-lbs", "LbsLinkdManager.start getLBSAddrs WT: seq=" + seq + " hardcodeIp=" + hardcodeIp);
                final ArrayList<InetAddress> wtAddrs = null;
                if (hardcodeIp) {
                    InetAddress[] wtLbsAddrs = null;
                    try {
                        Log.d("yysdk-lbs", "LbsLinkdManager.start resolve:119.167.206.135");
                        wtLbsAddrs = InetAddress.getAllByName(LbsLinkManager.HARDCODE_PRE_PUBLISH_WT_LBS_SERVER_ADDR);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                    if (wtLbsAddrs != null) {
                        wtAddrs = new ArrayList<>();
                        for (int i = 0; i < wtLbsAddrs.length && i < 3; i++) {
                            wtAddrs.add(wtLbsAddrs[i]);
                        }
                    }
                } else {
                    wtAddrs = LbsLinkManager.this.loadAddrs(LbsLinkManager.WT_LBS_NAME);
                    if (wtAddrs == null) {
                        InetAddress[] wtLbsAddrs2 = null;
                        try {
                            Log.d("yysdk-lbs", "LbsLinkdManager.start resolve:" + LbsLinkManager.this.WT_LBS_ADDR);
                            wtLbsAddrs2 = InetAddress.getAllByName(LbsLinkManager.this.WT_LBS_ADDR);
                        } catch (Exception e2) {
                            e2.printStackTrace();
                        }
                        if (wtLbsAddrs2 != null) {
                            wtAddrs = new ArrayList<>();
                            for (int i2 = 0; i2 < wtLbsAddrs2.length && i2 < 3; i2++) {
                                wtAddrs.add(wtLbsAddrs2[i2]);
                            }
                            if (!wtAddrs.isEmpty()) {
                                LbsLinkManager.this.saveAddrs(LbsLinkManager.WT_LBS_NAME, wtAddrs);
                            }
                        }
                    }
                }
                if (wtAddrs == null || wtAddrs.isEmpty()) {
                    Log.d("yysdk-lbs", "LbsLinkdManager.getLBSAddrs WT failed: seq=" + seq + " hardcodeIp=" + hardcodeIp);
                    LbsLinkManager.this.mCallHandler.post(new Runnable() { // from class: com.yy.sdk.lbs.LbsLinkManager.2.1
                        @Override // java.lang.Runnable
                        public void run() {
                            l.onGetFailed(seq);
                        }
                    });
                    return;
                }
                Log.d("yysdk-lbs", "LbsLinkdManager.getLBSAddrs WT success: seq=" + seq);
                LbsLinkManager.this.mCallHandler.post(new Runnable() { // from class: com.yy.sdk.lbs.LbsLinkManager.2.2
                    @Override // java.lang.Runnable
                    public void run() {
                        l.onGetSuccess(seq, wtAddrs);
                    }
                });
            }
        }.start();
        if (!TextUtils.isEmpty(this.HK_LBS_ADDR)) {
            new Thread() { // from class: com.yy.sdk.lbs.LbsLinkManager.3
                @Override // java.lang.Thread, java.lang.Runnable
                public void run() {
                    Log.d("yysdk-lbs", "LbsLinkdManager.start getLBSAddrs HK: seq=" + seq);
                    final ArrayList<InetAddress> hkAddrs = null;
                    if (hardcodeIp) {
                        InetAddress[] hkLbsAddrs = null;
                        try {
                            Log.d("yysdk-lbs", "LbsLinkdManager.start resolve:" + LbsLinkManager.this.HK_LBS_ADDR);
                            hkLbsAddrs = InetAddress.getAllByName(LbsLinkManager.this.HK_LBS_ADDR);
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                        if (hkLbsAddrs != null) {
                            hkAddrs = new ArrayList<>();
                            for (int i = 0; i < hkLbsAddrs.length && i < 3; i++) {
                                hkAddrs.add(hkLbsAddrs[i]);
                            }
                        }
                    } else {
                        hkAddrs = LbsLinkManager.this.loadAddrs(LbsLinkManager.HK_LBS_NAME);
                        if (hkAddrs == null) {
                            InetAddress[] hkLbsAddrs2 = null;
                            try {
                                Log.d("yysdk-lbs", "LbsLinkdManager.start resolve:" + LbsLinkManager.this.HK_LBS_ADDR);
                                hkLbsAddrs2 = InetAddress.getAllByName(LbsLinkManager.this.HK_LBS_ADDR);
                            } catch (Exception e2) {
                                e2.printStackTrace();
                            }
                            if (hkLbsAddrs2 != null) {
                                hkAddrs = new ArrayList<>();
                                for (int i2 = 0; i2 < hkLbsAddrs2.length && i2 < 3; i2++) {
                                    hkAddrs.add(hkLbsAddrs2[i2]);
                                }
                                if (!hkAddrs.isEmpty()) {
                                    LbsLinkManager.this.saveAddrs(LbsLinkManager.HK_LBS_NAME, hkAddrs);
                                }
                            }
                        }
                    }
                    if (hkAddrs == null || hkAddrs.isEmpty()) {
                        Log.d("yysdk-lbs", "LbsLinkdManager.getLBSAddrs HK failed: seq=" + seq);
                        LbsLinkManager.this.mCallHandler.post(new Runnable() { // from class: com.yy.sdk.lbs.LbsLinkManager.3.1
                            @Override // java.lang.Runnable
                            public void run() {
                                l.onGetFailed(seq);
                            }
                        });
                        return;
                    }
                    Log.d("yysdk-lbs", "LbsLinkdManager.getLBSAddrs HK success: seq=" + seq);
                    LbsLinkManager.this.mCallHandler.post(new Runnable() { // from class: com.yy.sdk.lbs.LbsLinkManager.3.2
                        @Override // java.lang.Runnable
                        public void run() {
                            l.onGetSuccess(seq, hkAddrs);
                        }
                    });
                }
            }.start();
        }
    }

    /* JADX INFO: Access modifiers changed from: private */
    public ArrayList<InetAddress> getRandomAddress(ArrayList<InetAddress> addrs, int count) {
        ArrayList<InetAddress> retAddrs = new ArrayList<>();
        if (addrs != null && !addrs.isEmpty() && count > 0) {
            if (addrs.size() <= count) {
                retAddrs.addAll(addrs);
                addrs.clear();
            } else {
                Random random = new Random(System.currentTimeMillis());
                for (int i = 0; i < count; i++) {
                    retAddrs.add(addrs.remove(random.nextInt(addrs.size())));
                }
            }
        }
        return retAddrs;
    }

    /* JADX INFO: Access modifiers changed from: private */
    public boolean doConnect(ArrayList<InetAddress> addrs) {
        int count = 0;
        if (addrs != null) {
            Iterator i$ = addrs.iterator();
            while (i$.hasNext()) {
                LbsLink link = new LbsLink(this);
                link.openLink(i$.next(), this.PORTS);
                synchronized (this.mConnectingLinks) {
                    this.mConnectingLinks.add(link);
                }
                count++;
            }
        }
        Log.d("yysdk-lbs", "LbsLinkdManager.doConnect, count=" + count);
        return count > 0;
    }

    /* JADX INFO: Access modifiers changed from: private */
    public void reportConnectResult(boolean success) {
        this.mIsConnecting = false;
        this.mCallHandler.removeCallbacks(this.mTimeoutTask);
        if (success) {
            this.mConnectListener.onLbsLinkConnect(true);
            return;
        }
        clearAddrs(LBS_NAME);
        clearAddrs(WT_LBS_NAME);
        clearAddrs(HK_LBS_NAME);
        this.mConnectListener.onLbsLinkConnect(false);
    }

    /* JADX INFO: Access modifiers changed from: private */
    public void compareSpeed(final boolean hardcodeIp) {
        this.mCompareSeq++;
        Log.d("yysdk-lbs", "LbsLinkdManager.compareSpeed mCompareSeq=" + this.mCompareSeq + " hardcodeIp=" + hardcodeIp);
        this.mCallHandler = new Handler();
        getLBSAddrs(this.mCompareSeq, hardcodeIp, new GetLbsAddrsListener() { // from class: com.yy.sdk.lbs.LbsLinkManager.5
            private int mFailCount;

            private void checkFailed() {
                this.mFailCount++;
                if (this.mFailCount < LbsLinkManager.this.DNS_FAIL_THRES) {
                    return;
                }
                if (!hardcodeIp) {
                    LbsLinkManager.this.compareSpeed(true);
                } else {
                    LbsLinkManager.this.reportConnectResult(false);
                }
            }

            @Override // com.yy.sdk.lbs.LbsLinkManager.GetLbsAddrsListener
            public void onGetSuccess(int seq, ArrayList<InetAddress> addrs) {
                Log.d("yysdk-lbs", "LbsLinkdManager.compareSpeed onGetSuccess mCompareSeq=" + LbsLinkManager.this.mCompareSeq + " hardcodeIp=" + hardcodeIp);
                if (seq == LbsLinkManager.this.mCompareSeq) {
                    synchronized (LbsLinkManager.this.mSelectedLinkSync) {
                        if (LbsLinkManager.this.mSelectedLink == null) {
                            if (addrs != null && addrs.size() > 0) {
                                StringBuilder sb = new StringBuilder();
                                sb.append("LbsLinkdManager.onGetSuccess:");
                                for (int i = 0; i < addrs.size(); i++) {
                                    sb.append(" (" + addrs.get(i) + ") ");
                                }
                                Log.d("yysdk-lbs", sb.toString());
                            }
                            ArrayList<InetAddress> connectAddrs = LbsLinkManager.this.getRandomAddress(addrs, LbsLinkManager.LBS_CONN_MAX_LIMIT);
                            if (connectAddrs != null && connectAddrs.size() > 0) {
                                StringBuilder sb2 = new StringBuilder();
                                sb2.append("LbsLinkdManager.getRandomAddress:");
                                for (int i2 = 0; i2 < connectAddrs.size(); i2++) {
                                    sb2.append(" (" + connectAddrs.get(i2) + ") ");
                                }
                                Log.d("yysdk-lbs", sb2.toString());
                            }
                            if (!LbsLinkManager.this.doConnect(connectAddrs)) {
                                checkFailed();
                            }
                        }
                    }
                }
            }

            @Override // com.yy.sdk.lbs.LbsLinkManager.GetLbsAddrsListener
            public void onGetFailed(int seq) {
                if (seq == LbsLinkManager.this.mCompareSeq) {
                    checkFailed();
                }
            }
        });
        this.mCallHandler.postDelayed(this.mTimeoutTask, (YYTimeouts.TCP_CONN_TIMEOUT * 2) + YYTimeouts.IP_READ_TIMEOUT);
    }

    public void onConnected(LbsLink pLink) {
        if (pLink != null) {
            YYDebug.logfile("yysdk-lbs", "Lbs link connected:" + pLink.getIp());
            synchronized (this.mSelectedLinkSync) {
                if (this.mSelectedLink == null) {
                    Log.v("yysdk-lbs", "LbsLinkdManager onConnected:" + pLink);
                    this.mSelectedLink = pLink;
                    this.mSelectedLink.setUriDataHandler(this);
                } else {
                    Log.v("yysdk-lbs", "LbsLinkdManager ignore:" + pLink);
                    pLink.closeLink();
                }
            }
            synchronized (this.mConnectingLinks) {
                this.mConnectingLinks.remove(pLink);
            }
            reportConnectResult(true);
        }
    }

    public void onError(LbsLink pLink) {
        if (pLink != null) {
            synchronized (this.mSelectedLinkSync) {
                if (this.mSelectedLink == pLink) {
                    this.mSelectedLink = null;
                }
            }
            pLink.closeLink();
            synchronized (this.mConnectingLinks) {
                this.mConnectingLinks.remove(pLink);
            }
            Log.v("yysdk-lbs", "LbsLinkdManager onError:" + pLink);
            if (this.mConnectingLinks.isEmpty() && !isConnected()) {
                Log.d("yysdk-lbs", "LbsLinkdManager mConnectingLinks empty");
                reportConnectResult(false);
            }
        }
    }

    public void selectFastestLink() {
        synchronized (this.mSelectedLinkSync) {
            if (this.mSelectedLink != null) {
                this.mConnectListener.onLbsLinkConnect(true);
                return;
            }
            this.mIsConnecting = true;
            clearLinks();
            compareSpeed(false);
        }
    }

    public boolean isConnecting() {
        return this.mIsConnecting;
    }

    @Override // com.yy.sdk.protocol.DataSource
    public boolean isConnected() {
        boolean z;
        synchronized (this.mSelectedLinkSync) {
            z = this.mSelectedLink != null;
        }
        return z;
    }

    @Override // com.yy.sdk.protocol.DataSource
    public boolean send(ByteBuffer data) {
        boolean sendData;
        synchronized (this.mSelectedLinkSync) {
            if (this.mSelectedLink == null) {
                Log.e("yysdk-lbs", "LbsLinkdManager send but no link");
                sendData = false;
            } else {
                sendData = this.mSelectedLink.sendData(data);
            }
        }
        return sendData;
    }

    @Override // com.yy.sdk.protocol.DataSource
    public boolean ensureSend(ByteBuffer bb, int resUri) {
        this.mEnsureSender.send(bb, resUri);
        return true;
    }

    @Override // com.yy.sdk.protocol.DataSource
    public void regUriHandler(int uri, UriDataHandler h) {
        ArrayList<UriDataHandler> handlerList = this.mHandlers.get(Integer.valueOf(uri));
        if (handlerList == null) {
            handlerList = new ArrayList<>();
            this.mHandlers.put(Integer.valueOf(uri), handlerList);
        }
        if (!handlerList.contains(h)) {
            handlerList.add(h);
        }
    }

    @Override // com.yy.sdk.protocol.DataSource
    public void unregUriHandler(int uri, UriDataHandler h) {
        ArrayList<UriDataHandler> handlerList = this.mHandlers.get(Integer.valueOf(uri));
        if (handlerList != null && handlerList.contains(h)) {
            handlerList.remove(h);
        }
    }

    @Override // com.yy.sdk.protocol.DataSource
    public void regWrapUriHandler(int uri, WrapUriDataHandler h) {
        throw new UnsupportedOperationException();
    }

    @Override // com.yy.sdk.protocol.DataSource
    public void unregWrapUriHandler(int uri, WrapUriDataHandler h) {
        throw new UnsupportedOperationException();
    }

    @Override // com.yy.sdk.protocol.UriDataHandler
    public void onData(int uri, ByteBuffer data, boolean hasHead) {
        if (YYDebug.DEBUG) {
            Log.v("yysdk-lbs", "LbsLink.onData,uri:" + uri + ",len:" + data.limit());
        }
        this.mEnsureSender.onRes(uri);
        ArrayList<UriDataHandler> handlerList = this.mHandlers.get(Integer.valueOf(uri));
        if (handlerList != null) {
            ArrayList<UriDataHandler> hl = new ArrayList<>();
            hl.addAll(handlerList);
            Iterator i$ = hl.iterator();
            while (i$.hasNext()) {
                UriDataHandler h = i$.next();
                if (handlerList.contains(h)) {
                    data.rewind();
                    h.onData(uri, data, hasHead);
                }
            }
            return;
        }
        Log.e("yysdk-lbs", "LbsLinkdManager no handler for uri:" + uri);
    }
}
