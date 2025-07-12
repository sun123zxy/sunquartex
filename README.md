# SunQuarTeX

基于 Quarto 的自用中英文学术写作模板库．支持输出至 HTML、PDF/LaTeX、Beamer、MS Word、GFM 等多种格式，覆盖交叉引用、插图绘制、定理系统等多种功能．

- [仓库主页](https://github.com/sun123zxy/sunquartex)
- [网页 Demo](https://sun123zxy.github.io/sunquartex)

## 核心功能

- 基于 Pandoc's Markdown 的完备学术写作语法
- 强大的交叉引用与定理系统功能
- HTML、PDF/LaTeX、Beamer、MS Word、Github Flavored Markdown (GFM) 全格式输出
- 嵌入 Python 代码生成数据图表（Computation）
- TikZ / [tikz-cd](https://ctan.org/pkg/tikz-cd) / [quiver](https://q.uiver.app/) 图表绘制
- Mermaid、Graphviz 图表绘制（Diagram）
- Github Actions 自动生成 Demo 站点
- ...

## 安装

安装方法简述如下，另可参见本仓库下的 Github Actions 配置文件．

- 下载并安装 [quarto-cli](https://github.com/quarto-dev/quarto-cli)．本仓库渲染使用 Quarto 版本为 {{< version >}}．

- （需要使用 Computation 等功能时）
  
  安装恰当版本的 Python 和所需模块，如 jupyter、numpy、matplotlib、tabulate 等．

- （需要输出 LaTeX / PDF / Beamer 时）
  
  请确保已安装 Quarto 支持的 LaTeX 发行版．若无，可使用 `quarto install tinytex --update-path` 安装．

- （需要使用 Mermaid、Graphviz 等 Diagram 功能且需输出 PDF）

  请确保已安装 Chrome 或 Chromium．若无，可使用 `quarto install tool chromium` 安装．（参见 [Quarto - Diagrams # Chrome Install](https://quarto.org/docs/authoring/diagrams.html#chrome-install)）

- （需要在非 LaTeX / PDF / Beamer 格式下（如 HTML）输出 TikZ 时）

  请确保 XeLaTeX、dvisvgm、mutool 已在 PATH 中，且已安装需要使用的 LaTeX 宏包（目前 TikZ 中使用的宏包无法在渲染过程中自动安装）．

  - 如使用 Quarto 自带的 TinyTeX 安装 `dvisvgm`：
  
    - 先输出一次示例 PDF 自动补全大部分所需宏包
    - 执行 `tlmgr install dvisvgm` 和 `tlmgr path add` 下载 dvisvgm 并添加至 PATH．

  - 如何安装 `mutool`：

    - （Linux / WSL）执行 `sudo apt install mupdf-tools`．
    - （Windows）请自行在 [MuPDF](https://mupdf.com/) 官网下载并安装 MuPDF，并确保 `mutool` 在 PATH 中．

  - 关于 mutool 必要性的一些说明：

    > As of Ghostscript 10.01.0, this will no longer work due to the introduction of a new PDF interpreter. Therefore, an alternative conversion module based on mutool, a utility which is part of the MuPDF package, has been introduced. It’s automatically invoked if Ghostscript can’t be used and if a working mutool executable is present in a directory which is part of the system’s search path.
    > 
    > 来自 [dvisvgm manual](https://dvisvgm.de/Manpage/)

## 使用

部分示例文件包含可选支持内容，如未安装相应依赖，可删除对应内容后渲染．

- `quarto render index-cnart.qmd`
- `quarto render index-enart.qmd`
- `quarto render index-cnpre.qmd`
- `quarto render index-enpre.qmd`

`--to` 参数可指定输出类型，包括 `html`, `pdf`， `beamer`, `docx`, `gfm`．每次渲染时应指定 `--to` 参数，或在文档头中 `format` 选项下列明输出格式．

在文件头声明 `lang=zh` 或 `lang=en` 即可调整语言．

输出 PDF 时，可在渲染时使用 `--to=latex` 选项输出 `.tex` 文件．

在 Beamer 中使用 TikZ 时，所在幻灯片须添加 `{.fragile}` 标记．

## Q&A

### 一般性的

#### 我不懂 Computer Science，你能不能讲人话！

请您活用 AI 工具降低学习门槛．推荐使用 VSCode 打开本仓库，使用自带的 Github Copilot，将 README 扔进对话框，提出您的具体需求并获得人话解答．

#### YAML 文档头是什么？怎么用？

示例文档中开头部分 `---` 之间的内容称为 YAML 文档头（YAML Front Matter），用于设置文档相关元信息，也用于设置输出格式、样式等．您在自定义的过程中可能需要修改或添加它们．

针对特定输出格式的设置请在文档头 `format` 下对应格式选项下设置．希望全局生效的设置（一般）可在文档头顶层设置．

#### 我想要 XXX 功能！/ 我要自己魔改！

仓库主要为自用，如能为你的生活带来便利欢迎取用．想要的功能欢迎提 Issue 或 Discussion，会考虑但不保证会做．有能力欢迎 Fork 魔改和 Pull Request．欢迎学习底层软件 Quarto．

### 写作相关

#### Markdown 语法？

速成可直接参考示例文档或 [Quarto](https://quarto.org/docs/authoring/markdown-basics.html) 官方教程．Quarto 使用的底层 Markdown 方言为 [Pandoc's Markdown](https://pandoc.org/MANUAL.html#pandocs-markdown)．

#### 我要画 TikZ / 交换图！

只输出 PDF / Beamer 只需要有 LaTeX 发行版．其它格式需要进一步安装．见安装部分．

交换图使用例：

`````qmd

```{tikz}
\begin{tikzcd}
	B && A & \rightsquigarrow & B && A
	\arrow[""{name=0, anchor=center, inner sep=0}, "g"{description}, from=1-3, to=1-1]
	\arrow[""{name=1, anchor=center, inner sep=0}, "f", curve={height=-30pt}, from=1-3, to=1-1]
	\arrow[""{name=2, anchor=center, inner sep=0}, "h"', curve={height=30pt}, from=1-3, to=1-1]
	\arrow[""{name=3, anchor=center, inner sep=0}, "h"', curve={height=30pt}, from=1-7, to=1-5]
	\arrow[""{name=4, anchor=center, inner sep=0}, "f", curve={height=-30pt}, from=1-7, to=1-5]
	\arrow["\alpha"', shorten <=4pt, shorten >=4pt, Rightarrow, from=1, to=0]
	\arrow["\beta"', shorten <=4pt, shorten >=4pt, Rightarrow, from=0, to=2]
	\arrow["{\beta \circ_1 \alpha}"', shorten <=8pt, shorten >=8pt, Rightarrow, from=4, to=3]
\end{tikzcd}
```
`````

推荐使用 [quiver](https://q.uiver.app/) 在线编辑器生成交换图代码．

#### 标题应该用多少个 `#`？

一般文档建议从二级标题开始编号（[相关讨论](https://community.rstudio.com/t/why-do-default-r-markdown-quarto-templates-use-second-level-headings-instead-of-first-level-ones/162127)）；Beamer 的 `slide-level` 可自适应标题级数，但其分节固定从一级标题开始，见 Pandoc 文档．

### 输出相关

#### Beamer 可不可以输出文稿版本 PDF？

理论上与文档格式兼容，可直接设置 `--to=pdf` 输出文稿版本．

#### 我要输出到知乎！

你可以使用 GFM 格式输出，输出内容可复制至 [markdown.com.cn](https://markdown.com.cn/editor/) 的在线编辑器转知乎格式．

#### 我要在线直播写文！（搭建在线网站）

本仓库同时采用 Github Actions + Github Pages 自动生成 Demo 站点．首次使用时，在 Actions 分页中激活 Actions，在本地手动进行第一次网站发布：

- 命令行内设置环境变量 `QUARTO_PROFILE` 为 `website`
- 执行 `quarto publish`
- （清除环境变量）

以后的每次 push 均会触发 Github Actions 自动完成的网站生成．

如需自定义网站域名，请在根目录下添加 CNAME 文件，并修改 `_quarto-website.yml` 下 `site-url`．

### 样式相关

#### 我要改字号！

目前仅支持 PDF 字号修改．英文文档默认字号为 10pt，中文文档默认字号为 10.5pt（五号，详见 CTeX 手册）．

```yaml
format:
  pdf:
    fontsize: 12pt
```

#### 我要 / 不想要目录！

```yaml
toc: true # 开启目录
```

该设置全局 / 特定格式下均生效．

#### 我不想给 section 编号 / 我要改 section 编号格式！

```yaml
number-sections: true # section 编号开关
number-depth: 3 # section 编号深度
```

该设置全局 / 特定格式下均生效．

#### 我不想给定理编号！/ 我要改定理编号格式！

Quarto 内置的定理编号系统无法修改，但我们提供通过 YAML 文档头自定义 PDF 格式定理编号的可能．（目前仍然无法实现完全关闭 PDF 格式中的定理编号）

```yaml
format:
  pdf:
    custom-theorem:
      numbered-within: section # 开启后将相对于 section（或 subsection, etc.）进行定理编号
      numbered-alike: true # 开启后不同类型的定理将共享编号
```

#### 我要改引用格式！

PDF / Beamer 输出使用 BibLaTeX alphabetical，HTML 输出使用 IEEE．如需修改，请自定义 `sun*****.cls` 和 `_format.yml` 和 CSL 文件．

#### 我要更丰富的 Callout 定理包裹样式！

请移步 [sun123zxy/quarto-callouty-theorem](https://github.com/sun123zxy/quarto-callouty-theorem) 学习配置方法．

#### 我要改 Beamer 幻灯片的颜色！

支持使用 YAML 文档头自定义部分颜色．

```yaml
format:
  beamer:
    custom-color:
    define: "\\definecolor{blueblk}{HTML}{1874D0}" # 在这里用 LaTeX 自定义颜色供后面使用
    main: "green!40!black" # 主色调
    theorem: "green!32!black" # 各种定理环境颜色
    example: "blueblk!50!black" # Example / Exercise 环境颜色
    remark: "white!15!black" # Proof / Solution / Remark 环境颜色
    link: "lime!85!black" # 链接颜色
```

#### PDF / Beamer 宏包不够用，我要自己导入！

```yaml
format:
  pdf:
    header-includes:
      text: \usepackage{euscript}
```

### 

## Known Issues

- 见 [Discussion #4598](https://github.com/quarto-dev/quarto-cli/discussions/4598)，Pandoc 不支持 CSL-M 导致无有效方法处理 GB/T 7714-2015 中按语言切换“等”、`et al` 省略字样的规定．

- 通用的定理编号目前尚难以自定义，见 [Discussion #5479](https://github.com/quarto-dev/quarto-cli/discussions/5479)

- （need repro）HTML 子图图像拉伸问题，似乎是因为没有设置 `height: auto`．

- 2025/04/15 定理标题中的文献引用导致 LaTeX 中出现嵌套中括号，见 [Issue #12584](https://github.com/quarto-dev/quarto-cli/issues/12584)

- 2025/06/29 目前 RST-style list tables 的 row-span 在 PDF 格式下支持不良．

- 2025/06/29 网站生成的 PDF 没有设置 base URL，相对链接无法正确解析．见 [Discussion #13000](https://github.com/quarto-dev/quarto-cli/discussions/13000)

- 2025/06/30 手机端的 other formats / links 菜单不显示，这是 Quarto 那边的问题，见 [Issue #5961](https://github.com/quarto-dev/quarto-cli/issues/5961)