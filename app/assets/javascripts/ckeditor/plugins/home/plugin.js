(function(){
    //Section 1 : 按下自定义按钮时执行的代码
    var a= {
        exec:function(editor){
          console.log();
          if (location.href.indexOf("table_template") != -1) { 
            location.href = "/table_templates";
          } else {
            location.href = "/projects";
          }
        }
    },
    //Section 2 : 创建自定义按钮、绑定方法
    b='home';
    CKEDITOR.plugins.add(b,{
        init:function(editor){
            editor.addCommand(b,a);
            editor.ui.addButton('home',{
                label:'返回',
                icon: this.path + 'home.png',
                command:b
            });
        }
    });
})();
