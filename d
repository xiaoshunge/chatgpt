package com.yy.sdk.proto;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.IBinder;
import android.os.RemoteException;
import androidx.annotation.NonNull;
import com.yy.huanju.util.j;
import com.yy.huanju.util.x;
import com.yy.sdk.a.a;
import com.yy.sdk.module.advert.d;
import com.yy.sdk.module.alert.c;
import com.yy.sdk.module.avatarbox.c;
import com.yy.sdk.module.emotion.b;
import com.yy.sdk.module.expand.b;
import com.yy.sdk.module.friend.d;
import com.yy.sdk.module.gift.c;
import com.yy.sdk.module.group.f;
import com.yy.sdk.module.msg.f;
import com.yy.sdk.module.nearby.b;
import com.yy.sdk.module.note.a;
import com.yy.sdk.module.promo.a;
import com.yy.sdk.module.prop.e;
import com.yy.sdk.module.recommond.b;
import com.yy.sdk.module.reward.b;
import com.yy.sdk.module.search.c;
import com.yy.sdk.module.serverconfig.a;
import com.yy.sdk.module.theme.a;
import com.yy.sdk.module.userinfo.k;
import com.yy.sdk.proto.a.e;
import com.yy.sdk.proto.linkd.a;
import com.yy.sdk.service.YYService;
import com.yy.sdk.stat.a;
import com.yy.sdk.util.f;
import com.yy.sdk.util.k;
import java.lang.ref.WeakReference;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicBoolean;
import sg.bigo.common.s;
import sg.bigo.core.b.b;
import sg.bigo.core.b.g;
import sg.bigo.sdk.message.service.c;
import sg.bigo.svcapi.c;
import sg.bigo.web.c.b;

/* compiled from: YYGlobals.java */
/* loaded from: classes.dex */
public class d {

    /* renamed from: a  reason: collision with root package name */
    private static final String f20677a = "d";

    /* renamed from: b  reason: collision with root package name */
    private static Context f20678b = null;

    /* renamed from: c  reason: collision with root package name */
    private static com.yy.sdk.a.a f20679c = null;
    private static int d = 3;
    private static final List<WeakReference<a>> e = new ArrayList();
    private static final b f = new b();
    private static ServiceConnection g = new ServiceConnection() { // from class: com.yy.sdk.proto.d.1
        @Override // android.content.ServiceConnection
        public void onServiceConnected(ComponentName componentName, IBinder iBinder) {
            com.yy.huanju.aa.b a2 = com.yy.huanju.aa.b.f11523a.a();
            a2.a(a2.a());
            com.yy.sdk.a.a unused = d.f20679c = a.AbstractBinderC0525a.a(iBinder);
            d.f.a(d.h);
            j.b("huanju-biz", "onServiceConnected " + d.f20679c);
            d.K();
            d.Q();
            d.b(true);
            if (x.a()) {
                x.c().f();
                x.b();
            }
            sg.bigo.hello.room.impl.stat.b.a(sg.bigo.common.a.c());
            IBinder iBinder2 = null;
            try {
                iBinder2 = d.f20679c.c(sg.bigo.sdk.push.a.a().g().getName());
            } catch (RemoteException e2) {
                e2.printStackTrace();
            }
            sg.bigo.sdk.push.a.a().a(d.f20678b, iBinder2);
        }

        @Override // android.content.ServiceConnection
        public void onServiceDisconnected(ComponentName componentName) {
            j.b("huanju-biz", "onServiceDisconnected");
            com.yy.sdk.bigostat.b.b(d.f20678b, null);
            com.yy.sdk.a.a unused = d.f20679c = null;
            d.L();
            sg.bigo.sdk.push.a.a().e();
        }
    };
    private static g h = new g() { // from class: com.yy.sdk.proto.d.12
        @Override // sg.bigo.core.b.g
        public IBinder a(String str) {
            try {
                return d.f20679c.c(str);
            } catch (RemoteException unused) {
                return null;
            }
        }
    };
    private static com.yy.sdk.proto.linkd.b i = new com.yy.sdk.proto.linkd.b();
    private static AtomicBoolean j = new AtomicBoolean(false);
    private static sg.bigo.core.b.d k = new sg.bigo.core.b.d() { // from class: com.yy.sdk.proto.d.20
        @Override // sg.bigo.core.b.d
        public void a(@NonNull Map<String, String> map) {
            sg.bigo.sdk.blivestat.a.d().a("0310049", map);
        }
    };

    /* compiled from: YYGlobals.java */
    /* loaded from: classes.dex */
    public interface a {
        void onYYServiceBound(boolean z);
    }

    public static void a(Context context, String str, int i2) {
        f20678b = context.getApplicationContext();
        if ("ppx".equals("hello")) {
            c.a((byte) 0);
        } else if ("ppx".equals("ppx")) {
            c.a((byte) 2);
        } else if ("ppx".equals("orangy")) {
            c.a((byte) 4);
        } else if ("ppx".equals("yinmi")) {
            c.a((byte) 6);
        } else {
            c.a((byte) 0);
        }
        c.a(1);
        sg.bigo.svcapi.util.c.a(f.i(), f.j(), f.k());
        d = i2;
        a(f20678b);
        boolean e2 = k.e(str);
        f.a(e2);
        f.a(k);
        J();
        if (e2) {
            f20679c = new c(f20678b);
            f.a(h);
        } else if (s.a(str)) {
            a();
        }
    }

    public static void a(Context context) {
        String f2 = com.yy.sdk.util.b.f(context);
        int e2 = com.yy.sdk.util.b.e(context);
        sg.bigo.svcapi.a.a("77C3E8D2-DE56-A0E0-9A3F-17BABE7C9799", "MTUxNUZBMzktRUJEOS0xOTVFLUYwNjAtMDJEM0Q5RjhBNzIx", com.yy.sdk.util.d.a(), 18, com.yy.sdk.a.f20037a, (short) 4631, null, !com.yy.sdk.util.b.b(context), f2, e2, true, false, d, true, false, false, (short) 0, "");
        sg.bigo.sdk.network.util.a.a(com.yy.sdk.config.g.e(context));
        sg.bigo.sdk.network.util.a.b(com.yy.sdk.util.d.a());
    }

    public static void a(String str) {
        M();
        com.yy.sdk.a.a aVar = f20679c;
        if (aVar != null) {
            try {
                aVar.b(str);
            } catch (RemoteException e2) {
                e2.printStackTrace();
            }
        }
    }

    private static void J() {
        f.a(e.class, new sg.bigo.core.b.e<Object>() { // from class: com.yy.sdk.proto.d.21
            @Override // sg.bigo.core.b.e
            public Object a(IBinder iBinder) {
                return e.a.a(iBinder);
            }
        });
        f.a(com.yy.sdk.proto.linkd.a.class, new sg.bigo.core.b.e<Object>() { // from class: com.yy.sdk.proto.d.22
            @Override // sg.bigo.core.b.e
            public Object a(IBinder iBinder) {
                return a.AbstractBinderC0612a.a(iBinder);
            }
        });
        f.a(com.yy.sdk.module.alert.c.class, new sg.bigo.core.b.e<Object>() { // from class: com.yy.sdk.proto.d.23
            @Override // sg.bigo.core.b.e
            public Object a(IBinder iBinder) {
                return c.a.a(iBinder);
            }
        });
        f.a(com.yy.sdk.module.userinfo.k.class, new sg.bigo.core.b.e<Object>() { // from class: com.yy.sdk.proto.d.24
            @Override // sg.bigo.core.b.e
            public Object a(IBinder iBinder) {
                return k.a.a(iBinder);
            }
        });
        f.a(sg.bigo.web.c.b.class, new sg.bigo.core.b.e<Object>() { // from class: com.yy.sdk.proto.d.25
            @Override // sg.bigo.core.b.e
            public Object a(IBinder iBinder) {
                return b.a.a(iBinder);
            }
        });
        f.a(sg.bigo.sdk.message.service.c.class, new sg.bigo.core.b.e<Object>() { // from class: com.yy.sdk.proto.d.26
            @Override // sg.bigo.core.b.e
            public Object a(IBinder iBinder) {
                return c.a.a(iBinder);
            }
        });
        f.a(com.yy.sdk.module.msg.f.class, new sg.bigo.core.b.e<Object>() { // from class: com.yy.sdk.proto.d.27
            @Override // sg.bigo.core.b.e
            public Object a(IBinder iBinder) {
                return f.a.a(iBinder);
            }
        });
        f.a(com.yy.sdk.module.friend.d.class, new sg.bigo.core.b.e<Object>() { // from class: com.yy.sdk.proto.d.2
            @Override // sg.bigo.core.b.e
            public Object a(IBinder iBinder) {
                return d.a.a(iBinder);
            }
        });
        f.a(com.yy.sdk.stat.a.class, new sg.bigo.core.b.e<Object>() { // from class: com.yy.sdk.proto.d.3
            @Override // sg.bigo.core.b.e
            public Object a(IBinder iBinder) {
                return a.AbstractBinderC0624a.a(iBinder);
            }
        });
        f.a(com.yy.sdk.module.advert.d.class, new sg.bigo.core.b.e<Object>() { // from class: com.yy.sdk.proto.d.4
            @Override // sg.bigo.core.b.e
            public Object a(IBinder iBinder) {
                return d.a.a(iBinder);
            }
        });
        f.a(com.yy.sdk.module.group.f.class, new sg.bigo.core.b.e<Object>() { // from class: com.yy.sdk.proto.d.5
            @Override // sg.bigo.core.b.e
            public Object a(IBinder iBinder) {
                return f.a.a(iBinder);
            }
        });
        f.a(com.yy.sdk.module.gift.c.class, new sg.bigo.core.b.e<Object>() { // from class: com.yy.sdk.proto.d.6
            @Override // sg.bigo.core.b.e
            public Object a(IBinder iBinder) {
                return c.a.a(iBinder);
            }
        });
        f.a(com.yy.sdk.module.emotion.b.class, new sg.bigo.core.b.e<Object>() { // from class: com.yy.sdk.proto.d.7
            @Override // sg.bigo.core.b.e
            public Object a(IBinder iBinder) {
                return b.a.a(iBinder);
            }
        });
        f.a(com.yy.sdk.module.theme.a.class, new sg.bigo.core.b.e<Object>() { // from class: com.yy.sdk.proto.d.8
            @Override // sg.bigo.core.b.e
            public Object a(IBinder iBinder) {
                return a.AbstractBinderC0592a.a(iBinder);
            }
        });
        f.a(com.yy.sdk.module.reward.b.class, new sg.bigo.core.b.e<Object>() { // from class: com.yy.sdk.proto.d.9
            @Override // sg.bigo.core.b.e
            public Object a(IBinder iBinder) {
                return b.a.a(iBinder);
            }
        });
        f.a(com.yy.sdk.module.promo.a.class, new sg.bigo.core.b.e<Object>() { // from class: com.yy.sdk.proto.d.10
            @Override // sg.bigo.core.b.e
            public Object a(IBinder iBinder) {
                return a.AbstractBinderC0572a.a(iBinder);
            }
        });
        f.a(com.yy.sdk.module.recommond.b.class, new sg.bigo.core.b.e<Object>() { // from class: com.yy.sdk.proto.d.11
            @Override // sg.bigo.core.b.e
            public Object a(IBinder iBinder) {
                return b.a.a(iBinder);
            }
        });
        f.a(com.yy.sdk.module.serverconfig.a.class, new sg.bigo.core.b.e<Object>() { // from class: com.yy.sdk.proto.d.13
            @Override // sg.bigo.core.b.e
            public Object a(IBinder iBinder) {
                return a.AbstractBinderC0590a.a(iBinder);
            }
        });
        f.a(com.yy.sdk.module.expand.b.class, new sg.bigo.core.b.e<Object>() { // from class: com.yy.sdk.proto.d.14
            @Override // sg.bigo.core.b.e
            public Object a(IBinder iBinder) {
                return b.a.a(iBinder);
            }
        });
        f.a(com.yy.sdk.module.search.c.class, new sg.bigo.core.b.e<Object>() { // from class: com.yy.sdk.proto.d.15
            @Override // sg.bigo.core.b.e
            public Object a(IBinder iBinder) {
                return c.a.a(iBinder);
            }
        });
        f.a(com.yy.sdk.module.nearby.b.class, new sg.bigo.core.b.e<Object>() { // from class: com.yy.sdk.proto.d.16
            @Override // sg.bigo.core.b.e
            public Object a(IBinder iBinder) {
                return b.a.a(iBinder);
            }
        });
        f.a(com.yy.sdk.module.prop.e.class, new sg.bigo.core.b.e<Object>() { // from class: com.yy.sdk.proto.d.17
            @Override // sg.bigo.core.b.e
            public Object a(IBinder iBinder) {
                return e.a.a(iBinder);
            }
        });
        f.a(com.yy.sdk.module.note.a.class, new sg.bigo.core.b.e<Object>() { // from class: com.yy.sdk.proto.d.18
            @Override // sg.bigo.core.b.e
            public Object a(IBinder iBinder) {
                return a.AbstractBinderC0569a.a(iBinder);
            }
        });
        f.a(com.yy.sdk.module.avatarbox.c.class, new sg.bigo.core.b.e<Object>() { // from class: com.yy.sdk.proto.d.19
            @Override // sg.bigo.core.b.e
            public Object a(IBinder iBinder) {
                return c.a.a(iBinder);
            }
        });
    }

    public static void a(a aVar) {
        synchronized (e) {
            Iterator<WeakReference<a>> it = e.iterator();
            while (it.hasNext()) {
                a aVar2 = it.next().get();
                if (aVar2 == null) {
                    it.remove();
                } else if (aVar2 == aVar) {
                    return;
                }
            }
            e.add(new WeakReference<>(aVar));
        }
    }

    public static void b(a aVar) {
        synchronized (e) {
            Iterator<WeakReference<a>> it = e.iterator();
            while (it.hasNext()) {
                a aVar2 = it.next().get();
                if (aVar2 == null || aVar2 == aVar) {
                    it.remove();
                }
            }
        }
    }

    /* JADX INFO: Access modifiers changed from: private */
    public static void b(boolean z) {
        ArrayList<a> arrayList = new ArrayList();
        synchronized (e) {
            Iterator<WeakReference<a>> it = e.iterator();
            while (it.hasNext()) {
                a aVar = it.next().get();
                if (aVar == null) {
                    it.remove();
                } else {
                    arrayList.add(aVar);
                }
            }
        }
        for (a aVar2 : arrayList) {
            aVar2.onYYServiceBound(z);
        }
    }

    public static synchronized void a() {
        synchronized (d.class) {
            if (b()) {
                j.d("huanju-biz", "YYGlobals.bound but already bound");
                return;
            }
            String a2 = s.a();
            if (!s.a(a2)) {
                j.e("mark", "avoid binding YYService from no UI process: " + a2);
                j.a("mark");
                return;
            }
            j.b("huanju-biz", "YYGlobals.bound." + a2);
            boolean z = false;
            try {
                try {
                    try {
                        Intent intent = new Intent(f20678b, YYService.class);
                        intent.putExtra("FromYYGlobal", true);
                        f20678b.startService(intent);
                        z = f20678b.bindService(intent, g, 65);
                    } catch (SecurityException e2) {
                        j.c("mark", "YYGlobals.bind YYService caught SecurityException", e2);
                    }
                } catch (IllegalStateException e3) {
                    j.c("mark", "YYGlobals.bind YYService caught IllegalStateException", e3);
                }
            } catch (IllegalArgumentException e4) {
                j.c("mark", "YYGlobals.bind YYService caught IllegalArgumentException", e4);
            } catch (Exception e5) {
                j.c("mark", "YYGlobals.bind YYService caught Exception", e5);
            }
            if (!z) {
                com.yy.sdk.bigostat.b.a(f20678b, null);
                j.e("mark", "YYGlobals.bind YYService return false!");
            } else if (x.a()) {
                x.c().e();
            }
        }
    }

    /* JADX INFO: Access modifiers changed from: private */
    public static void K() {
        if (!j.getAndSet(true)) {
            i.a(f20678b);
            sg.bigo.framework.d.e.a().d();
            sg.bigo.framework.d.e.a().c();
        }
    }

    /* JADX INFO: Access modifiers changed from: private */
    public static void L() {
        i.a();
        j.set(false);
    }

    public static boolean b() {
        com.yy.sdk.a.a aVar = f20679c;
        return aVar != null && aVar.asBinder().isBinderAlive();
    }

    private static void M() {
        if (!b() && f20678b != null) {
            a();
        }
    }

    public static com.yy.sdk.a.a c() {
        M();
        return f20679c;
    }

    public static com.yy.sdk.config.c d() {
        M();
        com.yy.sdk.a.a aVar = f20679c;
        if (aVar == null) {
            j.d("huanju-biz", "YYGlobals.config() sYYClient is null");
            return null;
        }
        if (aVar != null) {
            try {
                return aVar.j();
            } catch (RemoteException e2) {
                e2.printStackTrace();
            }
        }
        return null;
    }

    public static com.yy.sdk.proto.linkd.a e() {
        M();
        if (f20679c != null) {
            return (com.yy.sdk.proto.linkd.a) f.a((Class<Object>) com.yy.sdk.proto.linkd.a.class);
        }
        j.d("huanju-biz", "YYGlobals.linkd() sYYClient is null");
        return null;
    }

    public static com.yy.sdk.proto.linkd.b f() {
        return i;
    }

    public static com.yy.sdk.proto.a.e g() {
        M();
        if (f20679c != null) {
            return (com.yy.sdk.proto.a.e) f.a((Class<Object>) com.yy.sdk.proto.a.e.class);
        }
        j.d("huanju-biz", "YYGlobals.lbs() sYYClient is null");
        return null;
    }

    public static com.yy.sdk.module.group.f h() {
        M();
        if (f20679c != null) {
            return (com.yy.sdk.module.group.f) f.a((Class<Object>) com.yy.sdk.module.group.f.class);
        }
        j.d("huanju-biz", "YYGlobals.groupManager() sYYClient is null");
        return null;
    }

    public static com.yy.sdk.module.msg.f i() {
        M();
        if (f20679c != null) {
            return (com.yy.sdk.module.msg.f) f.a((Class<Object>) com.yy.sdk.module.msg.f.class);
        }
        j.d("huanju-biz", "YYGlobals.msgManager() sYYClient is null");
        return null;
    }

    public static com.yy.sdk.module.search.c j() {
        M();
        if (f20679c != null) {
            return (com.yy.sdk.module.search.c) f.a((Class<Object>) com.yy.sdk.module.search.c.class);
        }
        j.d("huanju-biz", "YYGlobals.searchManager() sYYClient is null");
        return null;
    }

    public static com.yy.sdk.module.note.a k() {
        M();
        if (f20679c != null) {
            return (com.yy.sdk.module.note.a) f.a((Class<Object>) com.yy.sdk.module.note.a.class);
        }
        j.d("huanju-biz", "YYGlobals.searchManager() sYYClient is null");
        return null;
    }

    public static com.yy.sdk.module.prop.e l() {
        M();
        if (f20679c != null) {
            return (com.yy.sdk.module.prop.e) f.a((Class<Object>) com.yy.sdk.module.prop.e.class);
        }
        j.d("huanju-biz", "YYGlobals.propManager() sYYClient is null");
        return null;
    }

    public static com.yy.sdk.module.userinfo.k m() {
        M();
        if (f20679c != null) {
            return (com.yy.sdk.module.userinfo.k) f.a((Class<Object>) com.yy.sdk.module.userinfo.k.class);
        }
        j.d("huanju-biz", "YYGlobals.appUserManager() sYYClient is null");
        return null;
    }

    public static sg.bigo.web.c.b n() {
        M();
        if (f20679c != null) {
            return (sg.bigo.web.c.b) f.a((Class<Object>) sg.bigo.web.c.b.class);
        }
        j.d("huanju-biz", "YYGlobals.getAppAuthToken() sYYClient is null");
        return null;
    }

    public static com.yy.sdk.module.emotion.b o() {
        M();
        if (f20679c != null) {
            return (com.yy.sdk.module.emotion.b) f.a((Class<Object>) com.yy.sdk.module.emotion.b.class);
        }
        j.d("huanju-biz", "YYGlobals.emotionManager() sYYClient is null");
        return null;
    }

    public static com.yy.sdk.module.theme.a p() {
        M();
        if (f20679c != null) {
            return (com.yy.sdk.module.theme.a) f.a((Class<Object>) com.yy.sdk.module.theme.a.class);
        }
        j.d("huanju-biz", "YYGlobals.themeManager() sYYClient is null");
        return null;
    }

    public static com.yy.sdk.module.gift.c q() {
        M();
        if (f20679c != null) {
            return (com.yy.sdk.module.gift.c) f.a((Class<Object>) com.yy.sdk.module.gift.c.class);
        }
        j.d("huanju-biz", "YYGlobals.giftManager() sYYClient is null");
        return null;
    }

    public static com.yy.sdk.module.reward.b r() {
        M();
        if (f20679c != null) {
            return (com.yy.sdk.module.reward.b) f.a((Class<Object>) com.yy.sdk.module.reward.b.class);
        }
        j.d("huanju-biz", "YYGlobals.rewardManager() sYYClient is null");
        return null;
    }

    public static com.yy.sdk.module.friend.d s() {
        M();
        if (f20679c != null) {
            return (com.yy.sdk.module.friend.d) f.a((Class<Object>) com.yy.sdk.module.friend.d.class);
        }
        j.d("huanju-biz", "YYGlobals.appBuddyManager() sYYClient is null");
        return null;
    }

    public static com.yy.sdk.module.promo.a t() {
        M();
        if (f20679c != null) {
            return (com.yy.sdk.module.promo.a) f.a((Class<Object>) com.yy.sdk.module.promo.a.class);
        }
        j.d("huanju-biz", "YYGlobals.promotionManager() sYYClient is null");
        return null;
    }

    public static com.yy.sdk.module.recommond.b u() {
        M();
        if (f20679c != null) {
            return (com.yy.sdk.module.recommond.b) f.a((Class<Object>) com.yy.sdk.module.recommond.b.class);
        }
        j.d("huanju-biz", "YYGlobals.recommondManager() sYYClient is null");
        return null;
    }

    public static com.yy.sdk.module.serverconfig.a v() {
        M();
        if (f20679c != null) {
            return (com.yy.sdk.module.serverconfig.a) f.a((Class<Object>) com.yy.sdk.module.serverconfig.a.class);
        }
        j.d("huanju-biz", "YYGlobals.serverConfigManager() sYYClient is null");
        return null;
    }

    public static com.yy.sdk.module.expand.b w() {
        M();
        if (f20679c != null) {
            return (com.yy.sdk.module.expand.b) f.a((Class<Object>) com.yy.sdk.module.expand.b.class);
        }
        j.d("huanju-biz", "YYGlobals.expandManager() sYYClient is null");
        return null;
    }

    public static com.yy.sdk.module.alert.c x() {
        M();
        if (f20679c != null) {
            return (com.yy.sdk.module.alert.c) f.a((Class<Object>) com.yy.sdk.module.alert.c.class);
        }
        j.d("huanju-biz", "YYGlobals.alertManager() sYYClient is null");
        return null;
    }

    public static com.yy.sdk.module.nearby.b y() {
        M();
        if (f20679c != null) {
            return (com.yy.sdk.module.nearby.b) f.a((Class<Object>) com.yy.sdk.module.nearby.b.class);
        }
        j.d("huanju-biz", "YYGlobals.nearbyManager() sYYClient is null");
        return null;
    }

    public static com.yy.sdk.stat.a z() {
        M();
        if (f20679c != null) {
            return (com.yy.sdk.stat.a) f.a((Class<Object>) com.yy.sdk.stat.a.class);
        }
        j.d("huanju-biz", "YYGlobals.getStatisticManager() sYYClient is null");
        return null;
    }

    public static com.yy.sdk.module.avatarbox.c A() {
        M();
        if (f20679c != null) {
            return (com.yy.sdk.module.avatarbox.c) f.a((Class<Object>) com.yy.sdk.module.avatarbox.c.class);
        }
        j.d("huanju-biz", "YYGlobals.avatarManager() sYYClient is null");
        return null;
    }

    private static sg.bigo.sdk.network.ipc.bridge.d N() throws YYServiceUnboundException {
        M();
        com.yy.sdk.a.a aVar = f20679c;
        if (aVar != null) {
            try {
                return aVar.g();
            } catch (RemoteException e2) {
                e2.printStackTrace();
                return null;
            }
        } else {
            throw new YYServiceUnboundException("getIPCServerHandler YYService is not bound yet");
        }
    }

    private static String O() throws YYServiceUnboundException {
        M();
        com.yy.sdk.a.a aVar = f20679c;
        if (aVar != null) {
            try {
                return aVar.h();
            } catch (RemoteException e2) {
                e2.printStackTrace();
                return null;
            }
        } else {
            throw new YYServiceUnboundException("getIPCServerLSAddress YYService is not bound yet");
        }
    }

    private static sg.bigo.sdk.network.ipc.a P() throws YYServiceUnboundException {
        M();
        com.yy.sdk.a.a aVar = f20679c;
        if (aVar != null) {
            try {
                return aVar.i();
            } catch (RemoteException e2) {
                e2.printStackTrace();
                return null;
            }
        } else {
            throw new YYServiceUnboundException("getIPCSeqGenerator YYService is not bound yet");
        }
    }

    public static boolean b(String str) {
        com.yy.sdk.a.a aVar = f20679c;
        if (aVar != null) {
            try {
                aVar.a(str);
                return true;
            } catch (RemoteException e2) {
                e2.printStackTrace();
            }
        }
        return false;
    }

    /* JADX INFO: Access modifiers changed from: private */
    public static void Q() {
        try {
            sg.bigo.sdk.network.ipc.bridge.d N = N();
            String O = O();
            if (N != null) {
                sg.bigo.sdk.network.ipc.b.a(N, P());
                sg.bigo.sdk.network.ipc.d.a(sg.bigo.sdk.network.ipc.b.a());
            } else if (O != null) {
                sg.bigo.sdk.network.ipc.b.a(O, P());
                sg.bigo.sdk.network.ipc.d.a(sg.bigo.sdk.network.ipc.b.a());
            } else {
                j.e("YYGlobals", "IPC Aidl and LS impl both empty!");
            }
        } catch (YYServiceUnboundException e2) {
            j.c("YYGlobals", "get IPCServer when YYService not binded", e2);
        }
    }

    public static sg.bigo.sdk.message.service.c B() throws YYServiceUnboundException {
        M();
        if (f20679c != null) {
            return (sg.bigo.sdk.message.service.c) f.a((Class<Object>) sg.bigo.sdk.message.service.c.class);
        }
        throw new YYServiceUnboundException("IServiceMessageManager YYService is not bound yet");
    }
}
