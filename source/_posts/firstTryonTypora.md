title: Typora——Markdown编辑界的极简主义

date: 2017/2/17 09:00:00

categories:

- Study

tags:

- BlogTools
- Markdown

---

### Before Typora

在Windows平台上，Typora之前，我还曾经接触过[MarkdownPad](http://www.markdownpad.com/)和[MarkPad](http://code52.org/DownmarkerWPF/)两款Markdown编辑工具。

MarkdownPad和MarkPad的特点：

- 都支持Markdown的所有语法，可以实现不动用鼠标就完成一篇排版精美文章的书写；
- 二者提供的都是两屏对照的实时渲染系统，即用户在左侧屏敲入带有Markdown语法的文字，在右侧屏会实时显示相应的HTML预览效果。
- 所生成的Markdown文件可以直接用于个人博客以及上传至Github，支持程度好。

不过，MarkdownPad和MarkPad仍有些许不同：

- MarkdownPad的实时渲染采用的是[Awesomium](http://www.awesomium.com/)，简单来说，Awesomium是一个HTML网页UI界面的渲染引擎，适用于基于C++或者.NET的应用程序。个人觉得，Awesomium对于一个Markdown编辑器来说，功能过于强大，以至于使得MarkdownPad的运行比较吃内存，有悖于Markdown轻量级编辑器的定位，同时在Windows10操作系统下实际使用的时候发现，内嵌于MarkdownPad中的Awesomium经常崩溃，出现无法渲染的情况，需要手动下载Awesomium SDK进行修复（据说安装SDK之后就可以修复，但是我没成功...）。
- MarkPad的渲染使用的是[JekyII](http://jekyll.com.cn/) ，一个基于Ruby语言的静态网页和网站生成工具。同时，JekyII还可以和Github结合，搭建一个免费静态博客。
- 此外，在外观和易用性上，MarkdownPad显得比较老气，风格与MS Office比较类似，常用标记功能的图标都列在菜单栏中，较为容易上手使用，MarkPad则较为有科技感，界面简洁，但是由于没有相应的常用功能列表，所以使用起来还需要经过一段时间的锻炼，适合已经熟悉Markdown语法的用户。

### Typora

Typora是也是一款本地的、所写即可见的Markdown编辑器。与上述两种Markdown编辑器一样，Typora支持相同的Markdown语法，也是一款可以不用鼠标操作的编辑器，所写的Markdown文件也可以直接用于博客静态网页的生成。

相比于MarkdownPad和MarkPad，Typora具有以下特点：

- 当前屏幕的实时渲染。Typora不再使用Preview窗口预览渲染的效果，而是直接在文字编辑窗口实时展现标记后的效果，这样一来减少了Preview窗口占用的面积，实际上就是增大了文字编辑区的面积，可以减少翻页查询上下文的操作和时间，同时，在标记语言完成输入之后，标记语言就会直接隐去，减少了所显示的文字数量，如要修改，只需要将光标放在标记语言的位置，标记语言就会显现出来。

  但是有一个问题是，目前发现标题（从一级到六级）只要样式一完成，即标记语言隐去之后，若想返回修改标题的级别，无法让标题的标记显现出来，只能先删除整个原标题，再重新标记。

- 界面左侧的文件列表和大纲。Typora编辑区左侧的文件列表和大纲可以通过菜单“View”——“Show Outline Panel”展示出来，文件列表展示当前编辑的文件信息，包括文件名、存储位置、上一次修改时间、字数等，大纲则会给出整篇文章的标题（从一级到六级），并提供跳转链接，类似于Word的导航窗格。

- 界面简洁，功能易找。Typora的界面十分简洁，只有上方一排文字菜单，整个编辑区很大，类似于MarkPad；但是其功能也十分容易找，在编辑区右键一下你就可以发现有很多的样式可以选择，这一点上又与MarkdownPad相似。可以说，Typora继承了MarkPad和MarkdownPad两者的优点，并且避开了他们的缺点。

- 界面主题多样。Typora的界面具有5种主题样式，除了基本日间和夜间界面主题之外，还有类似于书信和报刊的主题。

- 软件本身轻巧，不需要插件。Typora只需要安装即可使用，本身就可以完成实时渲染，不需要任何插件的帮助，开启关闭以及各种操作都很快捷迅速。

### Summary

Typora是一款很优秀、很简洁、很独特、很轻便、功能也很完善的Markdown编辑器，非常推荐使用。