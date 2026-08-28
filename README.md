# ImagePasteTool

Windows 图片剪贴板 / PureRef 多图粘贴工具。

## 功能

- 将资源管理器中复制的图片文件转换为“真正的图片剪贴板”并直接粘贴
- 支持直接复制的图片 / 截图内容
- 20 MB / 32 MB 上限，超过后自动压缩
- 批量一次性粘贴与逐张粘贴
- 边处理边粘贴 / 全部处理后再粘贴两种模式
- PureRef 多选图片独立导出与批量捕获
- PureRef 大图导出保护：综合导出窗口、CPU、I/O、目录变化和文件完整性判断完成状态
- 右下角置顶进度小窗，不抢焦点
- 历史剪贴板：标准分组模式 / 混合时间模式
- 历史保留 1 / 3 / 7 / 14 / 30 / 90 天或永久；只在程序启动时清理一次
- 便携配置与自定义数据 / 输出根目录
- GitHub Actions 自动构建无需 Python 的 Windows EXE

## 默认快捷键

| 功能 | 默认快捷键 |
| --- | --- |
| 普通粘贴 | `Alt + Win + V` |
| PureRef 多图捕获 | `Alt + Win + C` |
| 逐张粘贴 / 下一张 | `Ctrl + Alt + Win + V` |
| 打开历史剪贴板 | `Ctrl + Alt + Win + C` |

快捷键均可在设置窗口修改。

## 普通图片使用

### 复制图片文件

1. 在资源管理器中选中 JPG / PNG / WebP / BMP / TIFF / GIF 图片。
2. `Ctrl + C`。
3. 切换到 ChatGPT、Miro、Notion、Discord、浏览器、Office 等目标窗口。
4. 按 `Alt + Win + V`。
5. 工具将文件剪贴板转换成图片剪贴板，按当前设置检查 20 / 32 MB 上限，并直接粘贴。

### 直接复制图像

浏览器“复制图片”、截图工具、`Win + Shift + S`、Photoshop 等产生的图片剪贴板也可以直接处理。

## PureRef 多图捕获

1. 在 PureRef 中多选图片。
2. 按 `Alt + Win + C`。
3. ImagePasteTool 调用 PureRef 的独立图片导出，将该批图片导入队列。
4. 右下角进度窗显示导出 / 检测状态。
5. 切换到目标窗口。
6. 按普通粘贴快捷键批量粘贴，或用逐张快捷键逐张粘贴。

为了避免 PureRef 大图导出中途被误判为完成，当前版本同时观察：

- PureRef 导出命令是否已提交
- 导出窗口是否结束
- PureRef 进程磁盘写入 I/O
- PureRef 进程 CPU 活动
- 输出目录的文件名 / 大小 / 修改时间变化
- 已输出图片能否完整读取

只要 PureRef 仍在处理下一张大图，即使目录暂时没有变化，也会继续等待。

## 批量处理模式

### 边处理边粘贴

第 1 张处理完成后就开始粘贴，后台继续处理后面的图片。右下角显示类似：

`已处理 6/20 · 已粘贴 3/20`

### 全部处理完成后再粘贴

先把整批图片压缩 / 转码后写入本地磁盘缓存，再连续粘贴。适合追求粘贴阶段固定节奏的场景。

两种模式都采用硬盘缓存，避免整批高分辨率图片长期堆在 RAM。

## 历史剪贴板

普通 `Ctrl + C` 复制图片文件或图像时会自动写入历史。

- **标准模式**：一次复制 / 一次 PureRef 捕获 = 一行
- **混合模式**：所有历史图片按时间顺序统一排列
- 可以载入单张历史图片，也可以载入整组
- 历史回放不会重复写一份历史

默认历史保留 30 天。过期检查只在 ImagePasteTool 启动时执行一次，不会在运行期间频繁扫描。

## 图片大小限制

可选：

- 20 MB
- 32 MB

判断依据是准备写入剪贴板的 PNG 图像数据，而不只是源 JPG / PNG 文件大小。小于限制时不会主动缩小分辨率；超过限制时会逐步缩小并重新编码。

## 数据 / 输出目录

V2.3.5 起支持便携模式。

`config.json` 位于 `ImagePasteTool.exe` 同目录。

如果“数据 / 输出根目录”留空，默认使用：

```text
<ImagePasteTool.exe 所在目录>\ImagePasteTool_Data\
```

目录内容：

```text
ImagePasteTool_Data\
├─ PureRefCapture\   # PureRef 独立图片导出
├─ BatchCache\       # 批量处理临时缓存
├─ History\          # 历史剪贴板
└─ activity.log      # 本地日志
```

可以在设置中改到 `D:\...` / `E:\...`，用于 C 盘没有写入权限的电脑。修改后重启生效。

## 开发运行

需要 Windows + Python：

```bat
install_dev.bat
run_source.bat
```

## 构建无需 Python 的 Windows EXE

### 本地构建

构建电脑需要安装 Python，仅用于执行 PyInstaller：

```bat
build_windows_exe.bat
```

完成后：

```text
dist\ImagePasteTool.exe
```

最终 `ImagePasteTool.exe` 已包含 Python 运行时，目标电脑不需要安装 Python。

### GitHub Actions 构建

仓库包含：

```text
.github/workflows/build-windows.yml
```

在 GitHub 的 **Actions → Build Windows EXE → Run workflow** 中运行，构建完成后下载 `ImagePasteTool-Windows` artifact 即可得到 EXE。

## 主要依赖

- Pillow
- pystray
- pywinauto
- Windows Win32 API

## 当前版本

`V2.3.6`

本版本重点增加 PureRef 超大图片处理期间的 CPU 活动检测，并将 PureRef 最长导出保护时间提高到 600 秒。
