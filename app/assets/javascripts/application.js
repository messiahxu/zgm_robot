// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
//= require bootstrap
$(document).ready(function(){
  $('form').submit(function(){
    var now = new Date();
    now = now.format('yyyy-MM-dd hh:mm:ss');
    var receive = $('#receive').attr('value');
    var html = "<p class='time' style='color:red;'><span style='font-weight:bold;color:red;'>you</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + now + "<p class='words'>&nbsp;&nbsp;" + receive + "</p>";
    $("#chat-box").append(html);
    $('#chat-box')[0].scrollTop = 10000;
  });
  Date.prototype.format = function(format){  
    var o = {  
      "M+" : this.getMonth()+1,   
"d+" : this.getDate(),      
"h+" : this.getHours(),     
"m+" : this.getMinutes(),  
"s+" : this.getSeconds(),   
"q+" : Math.floor((this.getMonth()+3)/3),   
"S" : this.getMilliseconds()   
    }  
    if(/(y+)/.test(format)) format=format.replace(RegExp.$1,  
      (this.getFullYear()+"").substr(4 - RegExp.$1.length));  
    for(var k in o)if(new RegExp("("+ k +")").test(format))  
  format = format.replace(RegExp.$1,  
    RegExp.$1.length==1 ? o[k] :   
    ("00"+ o[k]).substr((""+ o[k]).length));  
    return format;  
  }  
});
