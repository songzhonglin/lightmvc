/**
 * 
 * @requires jQuery
 * 
 * 当页面加载完毕关闭加载进度
 * **/
$(window).load(function(){
	$("#loading").fadeOut();
});


/**
 * 使panel和datagrid在加载时提示
 * 
 * @requires jQuery,EasyUI
 * 
 */
$.fn.panel.defaults.loadingMessage = '加载中....';
$.fn.datagrid.defaults.loadMsg = '加载中....';

/**
 * @requires jQuery,EasyUI
 * 
 * panel关闭时回收内存，主要用于layout使用iframe嵌入网页时的内存泄漏问题
 */
$.fn.panel.defaults.onBeforeDestroy = function() {
	var frame = $('iframe', this);
	try {
		if (frame.length > 0) {
			for ( var i = 0; i < frame.length; i++) {
				frame[i].src = '';
				frame[i].contentWindow.document.write('');
				frame[i].contentWindow.close();
			}
			frame.remove();
			if (navigator.userAgent.indexOf("MSIE") > 0) {// IE特有回收内存方法
				try {
					CollectGarbage();
				} catch (e) {
				}
			}
		}
	} catch (e) {
	}
};

/**
 *  
 * 
 * @requires jQuery,EasyUI
 * 
 * 防止panel/window/dialog组件超出浏览器边界
 * @param left
 * @param top
 */
var easyuiPanelOnMove = function(left, top) {
	var l = left;
	var t = top;
	if (l < 1) {
		l = 1;
	}
	if (t < 1) {
		t = 1;
	}
	var width = parseInt($(this).parent().css('width')) + 14;
	var height = parseInt($(this).parent().css('height')) + 14;
	var right = l + width;
	var buttom = t + height;
	var browserWidth = $(window).width();
	var browserHeight = $(window).height();
	if (right > browserWidth) {
		l = browserWidth - width;
	}
	if (buttom > browserHeight) {
		t = browserHeight - height;
	}
	$(this).parent().css({/* 修正面板位置 */
		left : l,
		top : t
	});
};
$.fn.dialog.defaults.onMove = easyuiPanelOnMove;
$.fn.window.defaults.onMove = easyuiPanelOnMove;
$.fn.panel.defaults.onMove = easyuiPanelOnMove;

/**
 *  
 * 
 * @requires jQuery,EasyUI
 * 
 * 通用错误提示
 * 
 * 用于datagrid/treegrid/tree/combogrid/combobox/form加载数据出错时的操作
 */
var easyuiErrorFunction = function(XMLHttpRequest) {
	parent.$.messager.alert('错误', XMLHttpRequest.responseText);
};
$.fn.datagrid.defaults.onLoadError = easyuiErrorFunction;
$.fn.treegrid.defaults.onLoadError = easyuiErrorFunction;
$.fn.tree.defaults.onLoadError = easyuiErrorFunction;
$.fn.combogrid.defaults.onLoadError = easyuiErrorFunction;
$.fn.combobox.defaults.onLoadError = easyuiErrorFunction;
$.fn.form.defaults.onLoadError = easyuiErrorFunction;

/**
 *  
 * 
 * @requires jQuery,EasyUI
 * 
 * 为datagrid、treegrid增加表头菜单，用于显示或隐藏列，注意：冻结列不在此菜单中
 */
var createGridHeaderContextMenu = function(e, field) {
	e.preventDefault();
	var grid = $(this);/* grid本身 */
	var headerContextMenu = this.headerContextMenu;/* grid上的列头菜单对象 */
	if (!headerContextMenu) {
		var tmenu = $('<div style="width:100px;"></div>').appendTo('body');
		var fields = grid.datagrid('getColumnFields');
		for ( var i = 0; i < fields.length; i++) {
			var fildOption = grid.datagrid('getColumnOption', fields[i]);
			if (!fildOption.hidden) {
				$('<div iconCls="tick" field="' + fields[i] + '"/>').html(fildOption.title).appendTo(tmenu);
			} else {
				$('<div iconCls="bullet_blue" field="' + fields[i] + '"/>').html(fildOption.title).appendTo(tmenu);
			}
		}
		headerContextMenu = this.headerContextMenu = tmenu.menu({
			onClick : function(item) {
				var field = $(item.target).attr('field');
				if (item.iconCls == 'tick') {
					grid.datagrid('hideColumn', field);
					$(this).menu('setIcon', {
						target : item.target,
						iconCls : 'bullet_blue'
					});
				} else {
					grid.datagrid('showColumn', field);
					$(this).menu('setIcon', {
						target : item.target,
						iconCls : 'tick'
					});
				}
			}
		});
	}
	headerContextMenu.menu('show', {
		left : e.pageX,
		top : e.pageY
	});
};
$.fn.datagrid.defaults.onHeaderContextMenu = createGridHeaderContextMenu;
$.fn.treegrid.defaults.onHeaderContextMenu = createGridHeaderContextMenu;

/**
 * grid tooltip参数
 * 
 *  
 */
var gridTooltipOptions = {
	tooltip : function(jq, fields) {
		return jq.each(function() {
			var panel = $(this).datagrid('getPanel');
			if (fields && typeof fields == 'object' && fields.sort) {
				$.each(fields, function() {
					var field = this;
					bindEvent($('.datagrid-body td[field=' + field + '] .datagrid-cell', panel));
				});
			} else {
				bindEvent($(".datagrid-body .datagrid-cell", panel));
			}
		});

		function bindEvent(jqs) {
			jqs.mouseover(function() {
				var content = $(this).text();
				if (content.replace(/(^\s*)|(\s*$)/g, '').length > 5) {
					$(this).tooltip({
						content : content,
						trackMouse : true,
						position : 'bottom',
						onHide : function() {
							$(this).tooltip('destroy');
						},
						onUpdate : function(p) {
							var tip = $(this).tooltip('tip');
							if (parseInt(tip.css('width')) > 500) {
								tip.css('width', 500);
							}
						}
					}).tooltip('show');
				}
			});
		}
	}
};
/**
 * Datagrid扩展方法tooltip 基于Easyui 1.3.3，可用于Easyui1.3.3+
 * 
 * 简单实现，如需高级功能，可以自由修改
 * 
 * 使用说明:
 * 
 * 在easyui.min.js之后导入本js
 * 
 * 代码案例:
 * 
 * $("#dg").datagrid('tooltip'); 所有列
 * 
 * $("#dg").datagrid('tooltip',['productid','listprice']); 指定列
 * 
 *  
 */
$.extend($.fn.datagrid.methods, gridTooltipOptions);

/**
 * Treegrid扩展方法tooltip 基于Easyui 1.3.3，可用于Easyui1.3.3+
 * 
 * 简单实现，如需高级功能，可以自由修改
 * 
 * 使用说明:
 * 
 * 在easyui.min.js之后导入本js
 * 
 * 代码案例:
 * 
 * $("#dg").treegrid('tooltip'); 所有列
 * 
 * $("#dg").treegrid('tooltip',['productid','listprice']); 指定列
 * 
 *  
 */
$.extend($.fn.treegrid.methods, gridTooltipOptions);

/**
 *  
 * 
 * @requires jQuery,EasyUI
 * 
 * 扩展validatebox，添加验证两次密码功能
 */
$.extend($.fn.validatebox.defaults.rules, {
	eqPwd : {
		validator : function(value, param) {
			return value == $(param[0]).val();
		},
		message : '密码不一致！'
	},
	phoneNum: { //验证手机号   
        validator: function(value, param){ 
         return /^1[3-8]+\d{9}$/.test(value);
        },    
        message: '请输入正确的手机号。'   
    },
    telNum:{ //既验证手机号，又验证座机号
      validator: function(value, param){ 
          return /(^(0[0-9]{2,3}\-)?([2-9][0-9]{6,7})+(\-[0-9]{1,4})?$)|(^((\d3)|(\d{3}\-))?(1[358]\d{9})$)/.test(value);
         },    
         message: '请输入正确的联系方式。' 
    },
    idCard: {// 验证身份证
        validator: function (value) {
            return /^\d{15}(\d{2}[A-Za-z0-9])?$/i.test(value);
        },
        message: '身份证号码格式不正确'
    },
    qq: {// 验证QQ,从10000开始
        validator: function (value) {
            return /^[1-9]\d{4,9}$/i.test(value);
        },
        message: 'QQ号码格式不正确'
    },
    email: {// 验证邮箱
        validator: function (value) {
            return  /^([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+@([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+\.[a-zA-Z]{2,3}$/i.test(value);
        },
        message: '请输入有效的邮箱'
    },
    age: {// 验证年龄
        validator: function (value) {
            return /^(?:[1-9][0-9]?|1[01][0-9]|120)$/i.test(value);
        },
        message: '年龄必须是0到120之间的整数'
    },
    chinese: {// 验证中文
        validator: function (value) {
            return /^[\Α-\￥]+$/i.test(value);
        },
        message: '请输入中文'
    },
    chineseName:{
    	 validator: function (value) {
             return /^[\u4E00-\u9FA5]{1,6}$/i.test(value);
         },
         message: '请正确输入您的姓名'
    },
    english: {// 验证英语
        validator: function (value) {
            return /^[A-Za-z]+$/i.test(value);
        },
        message: '请输入英文'
    },
    loginName: {// 验证用户名
        validator: function (value) {
            return /^[a-zA-Z][a-zA-Z0-9_]{3,15}$/i.test(value);
        },
        message: '用户名不合法（字母开头，允许4-16字节，允许字母数字下划线）'
    },
    userName: {// 验证姓名，可以是中文或英文
        validator: function (value) {
            return /^[\Α-\￥]+$/i.test(value) | /^\w+[\w\s]+\w+$/i.test(value);
        },
        message: '请正确输入您的姓名，可以是中文或英文'
    },
    maxLength: {     
        validator: function(value, param){     
            return param[0] >= value.length;     
        },     
        message: '请输入最大{0}位字符.'    
    },
    minLength: {
        validator: function (value, param) {
            return value.length >= param[0];
        },
        message: '请输入最小{0}位字符.'
    },
    length: { validator: function (value, param) {
        var len = $.trim(value).length;
        return len >= param[0] && len <= param[1];
    },
        message: "输入内容长度必须介于{0}和{1}之间."
    },
    intOrFloat: {// 验证整数或小数
        validator: function (value) {
            return /^\d+(\.{1}\d+)?$/i.test(value);
        },
        message: '请输入数字，并确保格式正确'
    },
    integer: {// 验证整数 可正负数
        validator: function (value) {
            //return /^[+]?[1-9]+\d*$/i.test(value);

            return /^([+]?[0-9])|([-]?[0-9])+\d*$/i.test(value);
        },
        message: '请输入整数'
    },
    date: {// 验证姓名，可以是中文或英文
        validator: function (value) {
            //格式yyyy-MM-dd或yyyy-M-d
            return /^(?:(?!0000)[0-9]{4}([-]?)(?:(?:0?[1-9]|1[0-2])\1(?:0?[1-9]|1[0-9]|2[0-8])|(?:0?[13-9]|1[0-2])\1(?:29|30)|(?:0?[13578]|1[02])\1(?:31))|(?:[0-9]{2}(?:0[48]|[2468][048]|[13579][26])|(?:0[48]|[2468][048]|[13579][26])00)([-]?)0?2\2(?:29))$/i.test(value);
        },
        message: '清输入合适的日期格式'
    },
    selectValueRequired: {   
        validator: function(value,param){             
             if (value == "" || value.indexOf('请选择') >= 0) {   
                return false;  
             }else {  
                return true;  
             }    
        },   
        message: '该下拉框为必选项'   
    },
    positiveInteger: {   
        validator: function(value,param){             
             if ((/^[0-9]*[1-9][0-9]*$/.test(value))&& value>0) {   
                return true;  
             }else {  
                return false;  
             }    
        },   
        message: '请输入正整数！'   
    },
    floatingNumber: {   
        validator: function(value,param){             
             if ((/^(([0-9]+\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\.[0-9]+)|([0-9]*[1-9][0-9]*))$/.test(value))&& value>0) {   
                return true;  
             }else {  
                return false;  
             }    
        },   
        message: '请输入正浮点数！'   
    } ,
    number: {   
        validator: function(value,param){             
             if ((/^\d+(\.{1}\d+)?$/.test(value))&& value>0) {   
                return true;  
             }else {  
                return false;  
             }    
        },   
        message: '请输入数字！'   
    },
    pwd: {   
        validator: function(value,param){             
             if(value == null || value.length < 6){
            	 return false;
             }else{
            	 if ((/^[0-9a-zA-Z]+$/.test(value))) {
            		 return true;
            	 }else{
            		 return false;
            	 }
             }
        },   
        message: '密码只能由数字和字母组成且长度不小于6位！'   
    }
//    ,
//    isExist : {
//        validator : function(value, param) {
//            console.log(value);
//            var ret = " ";
//            $.ajax({
//                type : 'post',
//                async : false,
//                url : 'http://localhost:8080/testwechat/hello/check',
//                data : {
//                    "username" : username
//                },
//                success : function(data) {
//                	ret = data;
//                }
//            });
//            console.log(ret);
//            return ret.indexOf("true");
//        },
//        message : '用户名已经被占用'
//    }
	
});

//扩展tree，使其可以获取实心节点
$.extend($.fn.tree.methods, {
	getCheckedExt : function(jq) {// 获取checked节点(包括实心)
		var checked = $(jq).tree("getChecked");
		var checkbox2 = $(jq).find("span.tree-checkbox2").parent();
		$.each(checkbox2, function() {
			var node = $.extend({}, $.data(this, "tree-node"), {
				target : this
			});
			checked.push(node);
		});
		return checked;
	},
	getSolidExt : function(jq) {// 获取实心节点
		var checked = [];
		var checkbox2 = $(jq).find("span.tree-checkbox2").parent();
		$.each(checkbox2, function() {
			var node = $.extend({}, $.data(this, "tree-node"), {
				target : this
			});
			checked.push(node);
		});
		return checked;
	}
});

//扩展tree，使其支持平滑数据格式
$.fn.tree.defaults.loadFilter = function(data, parent) {
	var opt = $(this).data().tree.options;
	var idFiled, textFiled, parentField;
	if (opt.parentField) {
		idFiled = opt.idFiled || 'id';
		textFiled = opt.textFiled || 'text';
		parentField = opt.parentField;
		var i, l, treeData = [], tmpMap = [];
		for (i = 0, l = data.length; i < l; i++) {
			tmpMap[data[i][idFiled]] = data[i];
		}
		for (i = 0, l = data.length; i < l; i++) {
			if (tmpMap[data[i][parentField]] && data[i][idFiled] != data[i][parentField]) {
				if (!tmpMap[data[i][parentField]]['children'])
					tmpMap[data[i][parentField]]['children'] = [];
				data[i]['text'] = data[i][textFiled];
				tmpMap[data[i][parentField]]['children'].push(data[i]);
			} else {
				data[i]['text'] = data[i][textFiled];
				treeData.push(data[i]);
			}
		}
		return treeData;
	}
	return data;
};

// 扩展treegrid，使其支持平滑数据格式
$.fn.treegrid.defaults.loadFilter = function(data, parentId) {
	var opt = $(this).data().treegrid.options;
	var idFiled, textFiled, parentField;
	if (opt.parentField) {
		idFiled = opt.idFiled || 'id';
		textFiled = opt.textFiled || 'text';
		parentField = opt.parentField;
		var i, l, treeData = [], tmpMap = [];
		for (i = 0, l = data.length; i < l; i++) {
			tmpMap[data[i][idFiled]] = data[i];
		}
		for (i = 0, l = data.length; i < l; i++) {
			if (tmpMap[data[i][parentField]] && data[i][idFiled] != data[i][parentField]) {
				if (!tmpMap[data[i][parentField]]['children'])
					tmpMap[data[i][parentField]]['children'] = [];
				data[i]['text'] = data[i][textFiled];
				tmpMap[data[i][parentField]]['children'].push(data[i]);
			} else {
				data[i]['text'] = data[i][textFiled];
				treeData.push(data[i]);
			}
		}
		return treeData;
	}
	return data;
};

// 扩展combotree，使其支持平滑数据格式
$.fn.combotree.defaults.loadFilter = $.fn.tree.defaults.loadFilter;

/**
 * 
 * @requires jQuery,EasyUI
 * 
 * 创建一个模式化的dialog
 * 
 * @returns $.modalDialog.handler 这个handler代表弹出的dialog句柄
 * 
 * @returns $.modalDialog.xxx 这个xxx是可以自己定义名称，主要用在弹窗关闭时，刷新某些对象的操作，可以将xxx这个对象预定义好
 */
$.modalDialog = function(options) {
	if ($.modalDialog.handler == undefined) {// 避免重复弹出
		var opts = $.extend({
			title : '',
			width : 840,
			height : 680,
			modal : true,
			onClose : function() {
				$.modalDialog.handler = undefined;
				$(this).dialog('destroy');
			},
			onOpen : function() {
			}
		}, options);
		opts.modal = true;// 强制此dialog为模式化，无视传递过来的modal参数
		return $.modalDialog.handler = $('<div/>').dialog(opts);
	}
};


$.cookie = function(key, value, options) {
	if (arguments.length > 1 && (value === null || typeof value !== "object")) {
		options = $.extend({}, options);
		if (value === null) {
			options.expires = -1;
		}
		if (typeof options.expires === 'number') {
			var days = options.expires, t = options.expires = new Date();
			t.setDate(t.getDate() + days);
		}
		return (document.cookie = [ encodeURIComponent(key), '=', options.raw ? String(value) : encodeURIComponent(String(value)), options.expires ? '; expires=' + options.expires.toUTCString() : '', options.path ? '; path=' + options.path : '', options.domain ? '; domain=' + options.domain : '', options.secure ? '; secure' : '' ].join(''));
	}
	options = value || {};
	var result, decode = options.raw ? function(s) {
		return s;
	} : decodeURIComponent;
	return (result = new RegExp('(?:^|; )' + encodeURIComponent(key) + '=([^;]*)').exec(document.cookie)) ? decode(result[1]) : null;
};

/**
 * 
 * @requires jQuery
 * 
 * 将form表单元素的值序列化成对象
 * 
 * @returns object
 */
$.serializeObject = function(form) {
	var o = {};
	$.each(form.serializeArray(), function(index) {
		if (o[this['name']]) {
			o[this['name']] = o[this['name']] + "," + this['value'];
		} else {
			o[this['name']] = this['value'];
		}
	});
	return o;
};

/**
 * 
 * 增加formatString功能
 * 
 * 使用方法：$.formatString('字符串{0}字符串{1}字符串','第一个变量','第二个变量');
 * 
 * @returns 格式化后的字符串
 */
$.formatString = function(str) {
	for ( var i = 0; i < arguments.length - 1; i++) {
		str = str.replace("{" + i + "}", arguments[i + 1]);
	}
	return str;
};

/**
 * 
 * 接收一个以逗号分割的字符串，返回List，list里每一项都是一个字符串
 * 
 * @returns list
 */
$.stringToList = function(value) {
	if (value != undefined && value != '') {
		var values = [];
		var t = value.split(',');
		for ( var i = 0; i < t.length; i++) {
			values.push('' + t[i]);/* 避免他将ID当成数字 */
		}
		return values;
	} else {
		return [];
	}
};

/**
 * 
 * @requires jQuery
 * 
 * 改变jQuery的AJAX默认属性和方法
 */
$.ajaxSetup({
	type : 'POST',
	error : function(XMLHttpRequest, textStatus, errorThrown) {
		try {
			parent.$.messager.progress('close');
			parent.$.messager.alert('错误', XMLHttpRequest.responseText);
		} catch (e) {
			alert(XMLHttpRequest.responseText);
		}
	}
});


/**
 * 
 * @requires jQuery
 * 
 * 去掉空格
 * **/
String.prototype.trim = function() {
	return this.replace(/(^\s*)|(\s*$)/g, '');
};
String.prototype.ltrim = function() {
	return this.replace(/(^\s*)/g, '');
};
String.prototype.rtrim = function() {
	return this.replace(/(\s*$)/g, '');
};

/**
 * 
 * @requires jQuery
 * 
 * 页面加载加载进度条启用
 * **/
function progressLoad(){  
    $("<div class=\"datagrid-mask\" style=\"position:absolute;z-index: 9999;\"></div>").css({display:"block",width:"100%",height:$(window).height()}).appendTo("body");  
    $("<div class=\"datagrid-mask-msg\" style=\"position:absolute;z-index: 9999;\"></div>").html("正在处理，请稍候。。。").appendTo("body").css({display:"block",left:($(document.body).outerWidth(true) - 190) / 2,top:($(window).height() - 45) / 2});  
}

/**
 * 
 * @requires jQuery
 * 
 * 页面加载加载进度条关闭
 * **/
function progressClose(){
	$(".datagrid-mask").remove();  
	$(".datagrid-mask-msg").remove();
}
/**
 * 时间格式化
 */
function formatterDate(value,sdf){
//	if (value == null || value == '') {  
//        return '';  
//    }  
//	debugger;
//    var dt;  
//    if (value instanceof Date) {  
//        dt = value;  
//    } else {  
//        dt = new Date(value);  
//    }
//    if(sdf == null || sdf ==''){
//    	sdf = "yyyy-MM-dd HH:mm:ss";
//    }
//    return dt.format(sdf); //扩展的Date的format方法(上述插件实现)  
	if (value == undefined) {
        return "";
    }
	var date = new Date(value);
    var year = date.getFullYear().toString();
    var month = (date.getMonth() + 1);
    var day = date.getDate().toString();
    var hour = date.getHours().toString();
    var minutes = date.getMinutes().toString();
    var seconds = date.getSeconds().toString();
    if (month < 10) {
        month = "0" + month;
    }
    if (day < 10) {
        day = "0" + day;
    }
    if (hour < 10) {
        hour = "0" + hour;
    }
    if (minutes < 10) {
        minutes = "0" + minutes;
    }
    if (seconds < 10) {
        seconds = "0" + seconds;
    }
    return year + "-" + month + "-" + day + " " + hour + ":" + minutes + ":" + seconds;
}

/**  
 * 更换主题   
 */  
/*changeTheme = function(type){  
    var $easyuiTheme = $('#easyuiTheme');  
    debugger;
    var url = $easyuiTheme.attr('href');  
    console.info(url);  
    var href = url.substring(0, url.indexOf('easyui'))+ 'easyui/' + type + '/easyui.css';  
    console.info(href);  
    $easyuiTheme.attr('href',href);  
      
     // 如果使用了iframe  则要添加下面这段代码、否则的话iframe中的内容不会出现样式的改变  
    var $iframe = $('iframe');  
    if($ifram.length > 0){  
        for ( var i = 0; i < $iframe.length; i++) {  
            var ifr = $iframe[i];  
            $(ifr).contents.find('#easyuiTheme').attr('href', href);  
              
        }  
    }  
      
    $.cookie('easyuiThemeName', type, {  
        expires : 7  
    });  
}; */

/**
 * 
 * @requires jQuery
 * 
 * 防止退格键导致页面回退
 */
$(document).keydown(function (e) { 
	var doPrevent; 
	if (e.keyCode == 8) { 
		var d = e.srcElement || e.target; 
		if (d.tagName.toUpperCase() == 'INPUT' || d.tagName.toUpperCase() == 'TEXTAREA') { 
			doPrevent = d.readOnly || d.disabled; 
		}else{
			doPrevent = true; 
		}
	}else{ 
		doPrevent = false; 
	}
	if (doPrevent) 
	e.preventDefault(); 
});