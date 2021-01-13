$(".articles").ready(function() {
  $("#export-image-btn").click(function(){
    $(".main-image-ctn").each(function() {
      that = this
      domtoimage.toPng(that)
       .then(function (dataUrl) {
         var img = new Image();
         img.src = dataUrl;
         var name =new Date().getTime();
         downloadFile(name, dataUrl);
       })
       .catch(function (error) {
         console.error('oops, something went wrong!', error);
       });
    });
  });
  $("#export-detail-btn").click(function(){
    $(".detail-ctn-750").each(function() {
      that = this
      domtoimage.toPng(that)
       .then(function (dataUrl) {
         var img = new Image();
         img.src = dataUrl;
         var name =new Date().getTime();
         downloadFile(name, dataUrl);
       })
       .catch(function (error) {
         console.error('oops, something went wrong!', error);
       });
    });
  });
});
function downloadFile(fileName, content ) { //下载base64图片
	var base64ToBlob = function(code) {
		var parts = code.split(';base64,');
		var contentType = parts[0].split(':')[1];
		var raw = window.atob(parts[1]);
		var rawLength = raw.length;
		var uInt8Array = new Uint8Array(rawLength);
		for(var i = 0; i < rawLength; ++i) {
			uInt8Array[i] = raw.charCodeAt(i);
		}
		return new Blob([uInt8Array], {
			type: contentType
		});
	};
	var aLink = document.createElement('a');
	var blob = base64ToBlob(content); //new Blob([content]);
	var evt = document.createEvent("HTMLEvents");
	evt.initEvent("click", true, true); //initEvent 不加后两个参数在FF下会报错  事件类型，是否冒泡，是否阻止浏览器的默认行为
	aLink.download = fileName;
	aLink.href = URL.createObjectURL(blob);
	aLink.click();
};
