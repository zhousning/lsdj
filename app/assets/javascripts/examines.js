$(".exm_items").ready(function() {
  var leftNodes = gon.leftnodes; 
  var rightNodes = JSON.parse(gon.rightnodes); 
  var setting = {
		edit: {
			enable: true,
			showRemoveBtn: false,
			showRenameBtn: false
		},
		data: {
			simpleData: {
				enable: true 
			}
		},
		callback: {
      onDrag: zTreeOnDrag,
			beforeDrag: beforeDrag,
			beforeDrop: beforeDrop,
      onRightClick: OnRightClick
		}
	};
  /*var zNodes = [
    {name:"test1", open:true, children:[
      {name:"test1_1"}, {name:"test1_2"}]},
    {name:"test2", open:true, children:[
      {name:"test2_1"}, {name:"test2_2"}]}
  ];*/
  $.fn.zTree.init($("#treeLeft"), setting, leftNodes);
  $.fn.zTree.init($("#treeRight"), setting, rightNodes);

  zTree = $.fn.zTree.getZTreeObj("treeRight");
  rMenu = $("#rMenu");

  $("#test").click(function(){
    var nodes = zTree.transformToArray(zTree.getNodes());
    var json = getNodesJson(nodes);
    var json_str = JSON.stringify(json);
    console.log(json_str);
    var url = "/examines/" + gon.examine +"/create_drct";
    $.getJSON(url, {'drct_data': json_str}, function(data){
      alert(data['status']);
    });
    /*console.log(nodes);
    var arr = new Array(); 
    for(var i=0; i<nodes.length; i++){
      arr.push({name: nodes[i]['name'], tid: nodes[i]['tId'], pid: nodes[i]['parentTId']}); 
    }
    console.log(arr.toString());*/
  });

});

function getNodesJson(nodes){
  var root = nodes[0];
  var json = {};
  var arr = [];

  json.name = root.name;
  var child1 = root.children;

  node_recur(child1, arr);
  json.children = arr;
  return json;
}

//递归遍历所有节点形成json
function node_recur(child, arrs) {
  for (var i=0; i<child.length; i++){
    var json1 = {};
    var arr1 = [];
    json1.name = child[i].name;
    json1.isParent = child[i].isParent;
    
    if (child[i].children != undefined) 
    {
      var child2= child[i].children
      for (var j=0; j<child2.length; j++){
        var json2 = {};
        var arr2 = [];
        json2.name = child2[j].name
        json2.isParent = child2[j].isParent;
        
        if (child2[j].children != undefined)
        {
          var child3 = child2[j].children
          node_recur(child3, arr2);
          json2.children = arr2;
        }
        arr1.push(json2);
      }
      json1.children = arr1;
    }
    arrs.push(json1)
  }
}

//拖拽
function zTreeOnDrag(event, treeId, treeNodes) {
}
function beforeDrag(treeId, treeNodes) {
	for (var i=0,l=treeNodes.length; i<l; i++) {
		if (treeNodes[i].drag === false) {
			return false;
		}
  }
	return true;
}
function beforeDrop(treeId, treeNodes, targetNode, moveType) {
	return targetNode ? targetNode.drop !== false : true;
}
//右键菜单
function OnRightClick(event, treeId, treeNode) {
	if (!treeNode && event.target.tagName.toLowerCase() != "button" && $(event.target).parents("a").length == 0) {
		zTree.cancelSelectedNode();
		showRMenu("root", event.clientX, event.clientY);
	} else if (treeNode && !treeNode.noR) {
		zTree.selectNode(treeNode);
		showRMenu("node", event.clientX, event.clientY);
	}
}
function showRMenu(type, x, y) {
	$("#rMenu ul").show();
	if (type=="root") {
		$("#m_del").hide();
		$("#m_check").hide();
		$("#m_unCheck").hide();
	} else {
		$("#m_del").show();
		$("#m_check").show();
		$("#m_unCheck").show();
	}
    y += document.body.scrollTop;
    x += document.body.scrollLeft;
    rMenu.css({"top":y+"px", "left":x+"px", "visibility":"visible"});
		$("body").bind("mousedown", onBodyMouseDown);
}
function hideRMenu() {
	if (rMenu) rMenu.css({"visibility": "hidden"});
	$("body").unbind("mousedown", onBodyMouseDown);
}
function onBodyMouseDown(event){
	if (!(event.target.id == "rMenu" || $(event.target).parents("#rMenu").length>0)) {
		rMenu.css({"visibility" : "hidden"});
	}
}
var addCount = 1;
function addTreeNode() {
	hideRMenu();
	var newNode = { name:"增加" + (addCount++), isParent: true};
	if (zTree.getSelectedNodes()[0]) {
    if (zTree.getSelectedNodes()[0].isParent == true) {
		  newNode.checked = zTree.getSelectedNodes()[0].checked;
		  zTree.addNodes(zTree.getSelectedNodes()[0], newNode);
    }
	} else {
		zTree.addNodes(null, newNode);
	}
}
function removeTreeNode() {
	hideRMenu();
	var nodes = zTree.getSelectedNodes();
	if (nodes && nodes.length>0) {
		if (nodes[0].children && nodes[0].children.length > 0) {
			var msg = "确认全部删除吗?\n\n请确认！";
			if (confirm(msg)==true){
				zTree.removeNode(nodes[0]);
			}
		} else {
			zTree.removeNode(nodes[0]);
		}
	}
}
