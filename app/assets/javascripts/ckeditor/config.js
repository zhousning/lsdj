CKEDITOR.plugins.addExternal( 'home', '/assets/ckeditor/plugins/home/');

CKEDITOR.editorConfig = function (config) {

	config.toolbarGroups = [
		{ name: 'document', groups: [ 'mode', 'document', 'doctools' ] },
		{ name: 'clipboard', groups: [ 'clipboard', 'undo' ] },
		{ name: 'editing', groups: [ 'find', 'selection', 'spellchecker', 'editing' ] },
		{ name: 'forms', groups: [ 'forms' ] },
		{ name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ] },
		{ name: 'paragraph', groups: [ 'list', 'indent', 'blocks', 'align', 'bidi', 'paragraph' ] },
		{ name: 'links', groups: [ 'links' ] },
		{ name: 'insert', groups: [ 'insert' ] },
		{ name: 'styles', groups: [ 'styles' ] },
		{ name: 'colors', groups: [ 'colors' ] },
		{ name: 'tools', groups: [ 'tools' ] },
		{ name: 'others', groups: [ 'others' ] },
		{ name: 'about', groups: [ 'about' ] }
	];

	config.removeButtons = 'Maximize,Preview,NewPage,Templates,Find,Replace,SelectAll,Scayt,Form,Radio,TextField,Checkbox,Textarea,Select,Button,ImageButton,HiddenField,NumberedList,BulletedList,Outdent,Indent,Blockquote,CreateDiv,Language,Anchor,Unlink,Link,Flash,HorizontalRule,Smiley,SpecialChar,Iframe,Styles,TextColor,BGColor,ShowBlocks,About,CopyFormatting';

  //文件浏览器
  //config.filebrowserBrowseUrl = "/ckeditor/attachment_files";
  //config.filebrowserImageBrowseUrl = "/ckeditor/pictures";
  //config.filebrowserUploadUrl = "/ckeditor/attachment_files";
  
  config.filebrowserImageUploadUrl = "/ckeditor/pictures";
  config.filebrowserFlashBrowseUrl = "/ckeditor/attachment_files";
  config.filebrowserFlashUploadUrl = "/ckeditor/attachment_files";
  config.filebrowserImageBrowseLinkUrl = "/ckeditor/pictures";

  config.removeDialogTabs = 'image:advanced;link:advanced;table:advanced';

  config.language = "zh-cn";
  config.bodyClass = "document-editor A4";
  config.title = '&nbsp;';

  //config.fullPage = true;
  config.contentsCss = ['/assets/ckeditor/contents.css'];
  config.copyFormatting_allowedContexts = ['text', 'lists'];
  //查看dialog名称添加插件devtools
  config.extraPlugins = 'home,tableresize,pastefromword,image2,uploadimage,hcard';
  //移除编辑器下的标签显示
  config.removePlugins = 'elementspath';
  //config.stylesSet = 'my_styles';

  config.font_names = '宋体/SimSun;黑体/SimHei;' + config.font_names; 

  //config.resize_enabled = false;


}

  //CKEDITOR.stylesSet.add( 'my_styles', [
  //  { name: '表格边框', element: 'table', styles: { border: '2px solid black', 'border-collapse': 'collapse' } },
  //  { name: '表格单元格', element: 'p', styles: { border: '1px solid black' } }
  //  //{ name: 'Red Title',  element: 'h3', styles: { color: 'Red' } },
  //  //{ name: '表格', element: 'span', attributes: { 'class': 'ckeditor_my_table' } }
  //  //{ name: 'Marker: Yellow', element: 'span', styles: { 'background-color': 'Yellow' } }
  //]);
CKEDITOR.config.devtools_styles =
  '#cke_tooltip { line-height: 20px; font-size: 12px; padding: 5px; border: 2px solid #333; background: #ffffff }' +
  '#cke_tooltip h2 { font-size: 14px; border-bottom: 1px solid; margin: 0; padding: 1px; }' +
  '#cke_tooltip ul { padding: 0pt; list-style-type: none; }';

//全屏显示
CKEDITOR.on('instanceReady', function (event) {
  var editor = event.editor;
  setTimeout(function () {
    if (!editor.element) {
      setTimeout(arguments.callee, 100);
      return;
    }
    event.removeListener('instanceReady', this.callee);
    if (editor.name == 'content-table-template') {
      var command = editor.getCommand('maximize');
      command.exec();

      CKEDITOR.document.getById('contactList').on('dragstart', function(evt) {
        var target = evt.data.getTarget().getAscendant('div', true);
      
        CKEDITOR.plugins.clipboard.initDragDataTransfer(evt);
      
        var dataTransfer = evt.data.dataTransfer;
      
        dataTransfer.setData('contact', CONTACTS[target.data('contact')]);
      
        dataTransfer.setData('text/html', target.getText());
      
        if (dataTransfer.$.setDragImage) {
          dataTransfer.$.setDragImage(target.findOne('img').$, 0, 0);
        }
      });
    }
  }, 0);
}, null, null, 9999);

var CONTACTS = [{
    name: '单位公章'
  },
  {
    name: '全国注册建造师公章'
  },
  {
    name: '全国注册监理工程师公章'
  },
  {
    name: '专业注册监理工程师公章'
  },
  {
    name: '签名'
  }
];

CKEDITOR.plugins.add('hcard', {
  requires: 'widget',

  init: function(editor) {
    editor.widgets.add('hcard', {
      //allowedContent: 'span(!h-card); a[href](!u-email,!p-name); span(!p-tel)',
      allowedContent: 'span(!h-card); span(!p-sign)',
      requiredContent: 'span(h-card)',
      pathName: 'hcard',

      upcast: function(el) {
        return el.name == 'span' && el.hasClass('h-card');
      }
    });

    editor.addFeature(editor.widgets.registered.hcard);

    editor.on('paste', function(evt) {
      var contact = evt.data.dataTransfer.getData('contact');
      if (!contact) {
        return;
      }

      evt.data.dataValue =
        '<span class="h-card">' +
        '<span class="p-sign">' + contact.name + '</span>' +
        '</span>';
    });
  }
});

CKEDITOR.on( 'dialogDefinition', function( ev ) {
  var dialog = ev.data;
  var dialogName = ev.data.name;
  var dialogDefinition = ev.data.definition;

  if ( dialogName == 'table' ) {
    var info = dialogDefinition.getContents( 'info' );
    info.get( 'txtWidth' )[ 'default' ] = '100%';       // Set default width to 100%
    info.get( 'txtBorder' )[ 'default' ] = '2';         // Set default border to 0
  }
  if ( dialogName == 'image2' ) {
    dialogDefinition.onShow = function() {
      this.selectPage( 'Upload' );
    };
  }
});

