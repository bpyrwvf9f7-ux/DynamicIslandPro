# 灵动动动岛 · LingDong Island

把 **所有 App 的通知** 放进 iPhone 14 Pro 系列真实灵动岛位置的越狱插件。
面向 **iOS 16（16.0 – 16.6.1）+ Dopamine 无根越狱 + arm64e**。

安装后自动出现设置入口：**设置 → 灵动动动岛**。

![灵动动动岛 预览](docs/preview.png)

> 上图是界面示意（`docs/preview.png`）：展开卡片位于真实灵动岛位置，数秒后收起为胶囊。

**新手请先看图文教程：`docs/tutorial.html`**（浏览器打开，含建仓库、云端编译、下载 deb、安装、排错的完整步骤）。

---

## 1. 功能

| 功能 | 说明 |
| --- | --- |
| 全 App 通知上岛 | 不挑 App，只要系统会弹横幅的通知都会进岛 |
| 原生位置与形态 | 严格对齐灵动岛的胶囊位置、圆角、纯黑材质与弹簧动画 |
| 两种状态 | 先展开显示图标 / App 名 / 标题 / 正文 / 时间，再收成紧凑胶囊，最后淡出 |
| 替换系统横幅 | 默认用岛替换横幅，避免"岛 + 横幅"重复打扰（可关闭） |
| 点按 / 上滑 | 点按打开对应 App，上滑立即收起 |
| 多条通知 | 队列上限可调，紧凑态显示 `+N` 角标 |
| 触感反馈 | 上岛时轻触反馈（可关闭） |
| 实时生效 | 改设置立即生效，不需要注销 |

## 2. 兼容性

- 设备：iPhone 14 Pro / 14 Pro Max（带真实灵动岛）
- 系统：iOS 16.0 – 16.6.1
- 越狱：Dopamine（**无根 / rootless**，`/var/jb`）
- 架构：arm64e（会自动同时编出 arm64）
- 依赖：ElleKit（Dopamine 自带），其余无

> 注意：其它"无灵动岛"的机型需要用灵动岛模拟插件先把岛画出来，本插件只负责通知和岛上 UI。

## 3. 安装（用编译好的 deb）

1. 拿到 `com.lingdong.island_1.0.0_iphoneos-arm64.deb`。
2. 用 **Sileo / Zebra** 打开安装，或者 Filza 点开 deb 选择安装。
3. 安装完成后会提示注销，点注销；没有提示就手动注销一次 SpringBoard。
4. 打开 **设置 → 灵动动动岛**，先点「发送一条测试通知」确认生效。

命令行方式（NewTerm，需要 root）：

```sh
dpkg -i /var/mobile/com.lingdong.island_1.0.0_iphoneos-arm64.deb
killall -9 SpringBoard
```

## 4. 自己编译（推荐，零 Mac 成本）

### 方式 A：GitHub Actions（不需要 Mac）

1. 新建一个 GitHub 仓库，把本目录（`lingdong-island/`）里的全部文件推上去。
2. 仓库自带 `.github/workflows/build.yml`，推送后自动开始构建。
3. 打开仓库 **Actions → Build LingDong → 最新一次运行**。
4. 在页面底部 **Artifacts** 下载 `lingdong-island-deb`，解压即得 `.deb`。
5. 传到手机安装即可（见上一节）。

工作流会：安装 Theos + iPhoneOS 16.5 SDK → `make package FINALPACKAGE=1` → 上传 deb。
首次构建约 5–8 分钟。

> 手动触发：Actions 页面 → Build LingDong → Run workflow。

### 方式 B：macOS + Theos 本地编译

```sh
# 1. 准备环境
brew install ldid dpkg xz
export THEOS=$HOME/theos
git clone --recursive https://github.com/theos/theos.git "$THEOS"

# 2. 装 iOS 16.5 SDK
mkdir -p "$THEOS/sdks"
curl -L -o /tmp/sdk.tar.xz \
  https://github.com/theos/sdks/releases/latest/download/iPhoneOS16.5.sdk.tar.xz
tar -xf /tmp/sdk.tar.xz -C "$THEOS/sdks"

# 3. 编译（在 lingdong-island 目录里）
make package FINALPACKAGE=1
```

产物在 `packages/` 下。

> 不建议在 Linux 上编 arm64e：Theos 在非 macOS 环境会产出旧版 arm64e ABI，iOS 16 拒绝加载。
> 一定只能在 Linux 上编的话，删掉 `Makefile` 里的 `arm64e`，只保留 `arm64` 也能用。

## 5. 设置项

| 分组 | 项目 | 默认 | 作用 |
| --- | --- | --- | --- |
| 总开关 | 启用灵动岛通知 | 开 | 关掉后完全恢复系统横幅 |
| 通知行为 | 用灵动岛替换系统横幅 | 开 | 关掉则岛和横幅同时出现 |
| | 仅在解锁时上岛 | 开 | 锁屏时交给系统锁屏通知处理，避免重复 |
| | 显示通知正文 | 开 | 关掉只显示 App 名和标题 |
| | 显示 App 图标 | 开 | 关掉用首字母色块代替 |
| | 触感反馈 | 开 | 上岛时轻震 |
| 尺寸与位置 | 紧凑宽度 / 展开宽度 / 展开高度 / 垂直偏移 | 126 / 371 / 104 / 0 | 对齐原生尺寸，异常值自动纠正 |
| 显示时长 | 展开停留 / 收起后停留 | 4s / 7s | 控制整条通知在岛上的寿命 |
| 队列 | 队列上限 | 3 | 同时保留的通知条数，多出的显示 `+N` |
| 操作 | 发送测试通知 / 注销 SpringBoard / 恢复默认 | — | 调试与恢复 |

## 6. 它是怎么工作的

1. 插件以 dylib 注入 **SpringBoard**（`com.apple.springboard`）。
2. 用 `dlsym` 解析 `MSHookMessageEx`（ElleKit 提供），挂接通知横幅入口：
   `SBBannerManager`、`SBNotificationBannerDestination`、`SBBannerController` 上的
   `presentBanner:animated:` 与 `presentBanner:animated:completion:`。
3. 从横幅对象里深度优先找 `NCNotificationRequest`（`request` / `notificationRequest` /
   `presentable` / `bannerView` 等多条路径，全部 `respondsToSelector:` 保护），
   取出 `sectionIdentifier`、`content.title/message` 等字段。
   另外挂接 `NCNotificationContentView` 等类的 `configureWithNotificationRequest:` 作为内容兜底缓存。
4. 取到内容后按设置决定是否吞掉系统横幅，并把自己画的岛窗口（`UIWindowLevelAlert + 40`）
   显示在真实灵动岛的位置：紧凑胶囊 126 × 37.3、展开 371 × 104，圆角连续曲率，纯黑底，
   弹簧动画，点按穿透逻辑保证岛外区域不挡住系统触摸。
5. 设置写入 `com.lingdong.island` 偏好域，通过 Darwin 通知即时同步给 SpringBoard，
   无需注销。

### 关于"原生"的说明

- 显示位置就是 **硬件灵动岛本身**（纯黑胶囊与屏幕挖孔重合），不是屏幕中间飘的横幅，
  也不是给刘海机型伪造的"灵动岛"。
- 苹果 **没有** 向第三方开放"把任意通知塞进系统灵动岛进程"的 API（公开的 Live Activity
  只能由 App 自己发起）。所以岛上的通知卡片由插件绘制，但几何、材质、动画按原生规格对齐，
  视觉上与系统灵动岛一致。
- 这也是目前所有同类"通知上岛"插件的通用做法。

## 7. 常见问题

**装好没反应？**
- 确认是 Dopamine 无根越狱、设备是 iPhone 14 Pro 系列、系统 16.x。
- 确认安装后注销过 SpringBoard。
- 打开设置里的「发送一条测试通知」；仍然没反应就用 `idevicesyslog | grep 灵动` 看日志，
  正常应该能看到 `[灵动动动岛] 正在启动`、`SBBannerManager: 011`（1 表示钩子挂上了）
  以及真实通知到达时的 `上岛: ...`。

**只显示 App 名，没有标题正文？**
少数系统版本横幅对象里拿不到 `NCNotificationRequest`，插件会退回"最近一次内容缓存"。
如果长期如此，在 GitHub Issue 里附上系统小版本号即可。

**锁屏不显示？**
默认「仅在解锁时上岛」是开的，锁屏交给系统通知列表，避免打扰。需要锁屏也上岛就关掉它。

**通知重复（岛 + 横幅）？**
检查「用灵动岛替换系统横幅」是否被关掉。

**卸载**
Sileo 里卸载「灵动动动岛」，或 `dpkg -r com.lingdong.island`，然后注销。

## 8. 目录结构

```
lingdong-island/
├── Makefile                     # 主工程（rootless / arm64e）
├── control                      # 包信息
├── LingDong.plist               # 注入过滤器（仅 SpringBoard）
├── src/
│   ├── LDCommon.h               # 宏与安全反射工具
│   ├── LDPrefs.h/.m             # 偏好读取
│   ├── LDNotificationItem.h/.m  # 横幅 → 通知模型（含请求解析）
│   ├── LDIslandViewController.h/.m # 岛 UI 与动画、手势
│   ├── LDNotifier.h/.m          # 窗口、队列、计时器、打开 App
│   └── LDTweak.m                # 构造入口 + 方法钩子
├── prefs/                       # 设置面板（PreferenceBundle）
├── layout/                      # 安装布局（设置入口与资源）
└── .github/workflows/build.yml  # 一键出 deb
```

## 9. 许可

仅供个人学习与自用。请勿二次售卖或打包进收费源。
