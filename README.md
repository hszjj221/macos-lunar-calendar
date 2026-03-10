# macOS 万年历状态栏 App

一个轻量的 macOS 原生状态栏日历应用，点击图标即可查看本月万年历。

## 功能特性

- **状态栏常驻**：仅在菜单栏显示图标，不占用 Dock 空间
- **公历 + 农历**：每个日期格同时显示公历日和农历日
- **二十四节气**：内置 2024–2030 年节气数据，精确到日
- **传统节日**：春节、元宵、端午、七夕、中秋、重阳等农历节日
- **干支纪年**：标题栏显示当前农历年的天干地支
- **今日高亮**：今天以蓝色圆圈标注
- **月份切换**：◀ ▶ 按钮自由切换月份，一键回到今天

## 截图

> 点击菜单栏日历图标，弹出万年历弹窗。

```
        2026年3月
         丙午年
  日  一  二  三  四  五  六
   1   2   3   4   5   6   7
  惊蛰 初六 初七 初八 初九 初十 十一
   8   9  10  11  12  13  14
  十二 十三 十四 十五 十六 十七 十八
  ...
              今天
```

## 环境要求

- macOS 14.0+
- Swift 5.9+ / Xcode Command Line Tools

## 构建与运行

```bash
# 克隆仓库
git clone https://github.com/hszjj221/macos-lunar-calendar.git
cd macos-lunar-calendar

# 一键构建并运行
make run

# 仅构建（生成 CalendarApp.app）
make build

# 清理构建产物
make clean
```

## 项目结构

```
.
├── Package.swift                          # Swift Package Manager 配置
├── Makefile                               # 构建脚本
└── Sources/CalendarApp/
    ├── App.swift                          # @main 入口，隐藏 Dock 图标
    ├── StatusBarController.swift          # 状态栏图标与弹窗管理
    ├── Views/
    │   ├── CalendarPopoverView.swift      # 弹窗根视图（标题 + 网格）
    │   ├── MonthGridView.swift            # 7列月历网格
    │   └── DayCellView.swift              # 单日格（公历 + 农历 + 标注）
    ├── Models/
    │   ├── CalendarDay.swift              # 日期数据模型
    │   └── LunarCalendarHelper.swift      # 农历/节气/节日/干支计算
    └── Resources/
        └── Info.plist                     # LSUIElement=YES，隐藏 Dock
```

## 技术说明

- 农历转换基于系统 `Calendar(identifier: .chinese)`，无需第三方库
- 节气数据硬编码 2024–2030 年共 168 条记录，简单可靠
- 干支纪年以农历年为准计算（正月初一前仍属上一年）
- 使用 SwiftUI + AppKit 混合构建，`NSPopover` 提供系统原生圆角与阴影

## License

MIT
