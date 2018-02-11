<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="inc.jsp"></jsp:include>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><spring:message code="sales.management.platform"/></title>
<script type="text/javascript">
	var index_layout;
	var index_tabs;
	var index_tabsMenu;
	var layout_west_tree;
	var layout_west_tree_url = '';
	
	var sessionInfo_userId = '${sessionInfo.id}';
	if (sessionInfo_userId) {//如果没有登录,直接跳转到登录页面
		layout_west_tree_url = '${ctx}/resource/tree';
	}else{
		window.location.href='${ctx}/admin/index';
	}
	$(function() {
		index_layout = $('#index_layout').layout({
			fit : true
		});
		
		index_tabs = $('#index_tabs').tabs({
			fit : true,
			border : false,
			tools : [{
				iconCls : 'icon-home',
				handler : function() {
					index_tabs.tabs('select', 0);
				}
			}, {
				iconCls : 'icon-refresh',
				handler : function() {
// 					var index = index_tabs.tabs('getTabIndex', index_tabs.tabs('getSelected'));
// 					index_tabs.tabs('getTab', index).panel('open').panel('refresh');
						var index = index_tabs.tabs('getTabIndex', index_tabs.tabs('getSelected'));
						var tab = index_tabs.tabs('getTab', index);
		        		var url = $(tab.panel('options').content).attr('src');
		        		if(url!=undefined){
			        		var iframe = '<iframe src="' + url + '" frameborder="0" style="border:0;width:100%;height:99.5%;"></iframe>';
			        		$('#index_tabs').tabs('update', {
					            tab: tab,
					            options: {
					                content: iframe
					            }
					        });
		        		}
				}
			}, {
				iconCls : 'icon-del',
				handler : function() {
					var index = index_tabs.tabs('getTabIndex', index_tabs.tabs('getSelected'));
					var tab = index_tabs.tabs('getTab', index);
					if (tab.panel('options').closable) {
						index_tabs.tabs('close', index);
					}
				}
			} ]
		});
		
		layout_west_tree = $('#layout_west_tree').tree({
			url : layout_west_tree_url,
			parentField : 'pid',
			lines : true,
			onClick : function(node) {
				if (node.attributes && node.attributes.url) {
					var url = '${ctx}' + node.attributes.url;
					addTab({
						url : url,
						title : node.text,
						iconCls : node.iconCls
					});
				}
			},
			onLoadSuccess: function (node, data) {
			      if (data) {
			        $(data).each(function (index, d) {
			        //只展开2级
			          if (this.state == 'closed') {
			           /*  var children = $('#layout_west_tree').tree('getChildren');
			            for (var i = 0; i < children.length; i++) {
			              $('#layout_west_tree').tree('expand', children[i].target);
			            } */
			            //全部打开 、合并操作
			            $('#layout_west_tree').tree('expandAll');
			            //$(‘#’ + treeId).tree(“collapseAll”);
			          }
			         });
			      }
			    }
		});
		
		   //监听右键事件，创建右键菜单
        $('#index_tabs').tabs({
            onContextMenu: function (e, title, index) {
                e.preventDefault();
                if (index > 0) {
                    $('#mm').menu('show', {
                        left: e.pageX,
                        top: e.pageY
                    }).data("tabTitle", title);
                }
            }
        });
        //右键菜单click
        $("#mm").menu({
            onClick: function (item) {
                closeTab(this, item.name);
            }
        });
	});
	
	//删除Tabs
    function closeTab(menu, type) {
        var allTabs = $("#index_tabs").tabs('tabs');
        var currTab = $('#index_tabs').tabs('getSelected');
        var allTabtitle = [];
        $.each(allTabs, function (i, n) {
            var opt = $(n).panel('options');
            if (opt.closable)
                allTabtitle.push(opt.title);
        });
        var curTabTitle = $(menu).data("tabTitle");
        var curTabIndex = $("#index_tabs").tabs("getTabIndex", $("#index_tabs").tabs("getTab", curTabTitle));
        switch (type) {
            case "1":
                $("#index_tabs").tabs("close", curTabIndex);
                return false;
                break;
            case "2":
                for (var i = 0; i < allTabtitle.length; i++) {
                    $('#index_tabs').tabs('close', allTabtitle[i]);
                }
                break;
            case "3":
                for (var i = 0; i < allTabtitle.length; i++) {
                    if (curTabTitle != allTabtitle[i])
                        $('#index_tabs').tabs('close', allTabtitle[i]);
                }
                $('#index_tabs').tabs('select', curTabTitle);
                break;
            case "4":
                for (var i = curTabIndex; i < allTabtitle.length; i++) {
                    $('#index_tabs').tabs('close', allTabtitle[i]);
                }
                $('#index_tabs').tabs('select', curTabTitle);
                break;
            case "5":
                for (var i = 0; i < curTabIndex-1; i++) {
                    $('#index_tabs').tabs('close', allTabtitle[i]);
                }
                $('#index_tabs').tabs('select', curTabTitle);
                break;
            case "6": //刷新
                var panel = $("#index_tabs").tabs("getTab", curTabTitle).panel("refresh");
        		var url = $(currTab.panel('options').content).attr('src');
        		var iframe = '<iframe src="' + url + '" frameborder="0" style="border:0;width:100%;height:99.5%;"></iframe>';
        		$('#index_tabs').tabs('update', {
		            tab: currTab,
		            options: {
		                content: iframe
		            }
		        });
                break;
        }
    }
	
	
	function addTab(params) {
		var iframe = '<iframe src="' + params.url + '" frameborder="0" style="border:0;width:100%;height:99.5%;"></iframe>';
		var t = $('#index_tabs');
		var opts = {
			title : params.title,
			closable : true,
			iconCls : params.iconCls,
			content : iframe,
			border : false,
			fit : true
		};
		if (t.tabs('exists', opts.title)) {
			t.tabs('select', opts.title);
		} else {
			t.tabs('add', opts);
		}
	}
	
	function logout(){
		$.messager.confirm('提示','确定要退出?',function(r){
			if (r){
				progressLoad();
				$.post( '${ctx}/admin/logout', function(result) {
					if(result.success){
						progressClose();
						window.location.href='${ctx}/admin/index';
					}
				}, 'json');
			}
		});
	}
	

	function editUserPwd() {
		parent.$.modalDialog({
			title : '<spring:message code="change.password"/>',
			width : 350,
			height : 250,
			href : '${ctx}/user/editPwdPage',
			buttons : [  {
				text : '<spring:message code="change.password"/>',
				handler : function() {
					var f = parent.$.modalDialog.handler.find('#editUserPwdForm');
					f.submit();
				}
			},{
				text : '<spring:message code="close.the.window"/>',
				handler : function() {
					parent.$.modalDialog.handler.dialog('destroy');
					parent.$.modalDialog.handler = undefined;
				}
			} ]
		});
	}
	
	function showUserInfo(){
		alert("ss");
	}
</script>
</head>
<body>
	<div id="loading" style="position: fixed;top: -50%;left: -50%;width: 200%;height: 200%;background: #fff;z-index: 100;overflow: hidden;">
	<img src="${ctx}/style/images/ajax-loader.gif" style="position: absolute;top: 0;left: 0;right: 0;bottom: 0;margin: auto;"/>
	</div>
	<div id="index_layout">
		<div data-options="region:'north',border:false" style=" overflow: hidden;" >
			<div id="header">
<!-- 				<a href="javascript:void(0)" style=" background-color: white;" id="mb">设置</a> -->
				<span style="float: right; padding-right: 20px;">
				[在线人数：${lineCount}人]
				 [<spring:message code="language"/>: <a href="?lang=zh_CN" style="color:red;"><spring:message code="language.cn" /></a> - <a href="?lang=en_US" style="color: red;"><spring:message code="language.en" /></a>][<strong>${sessionInfo.name}</strong>]，欢迎您！您使用[<strong>${sessionInfo.ip}</strong>]IP登录！
<!-- 				 <a href="javascript:void(0)" onclick="editUserPwd()" style="color: #fff;cursor: pointer;text-decoration: none;">修改密码</a>&nbsp;&nbsp; -->
<!-- 				 <a href="javascript:void(0)" onclick="logout()" style="color: #fff;cursor: pointer;text-decoration: none;">安全退出</a>  -->
				 &nbsp;&nbsp;&nbsp;&nbsp;
				 &nbsp;&nbsp;&nbsp;&nbsp;
				 <div style="position: absolute; right: 0px; bottom: 0px;text-align: center; ">
					<a href="javascript:void(0);" class="easyui-menubutton" style="height: 16px; background-color: #fff"
					data-options="menu:'#layout_north_kzmbMenu',iconCls:'icon-man'"></a>
				</div>
				<div id="layout_north_kzmbMenu" style="width: 100px; display: none;">
					<div onclick="showUserInfo();"><spring:message code="personal.information"/></div>
					<div onclick="editUserPwd();"><spring:message code="change.password"/></div>
					<div onclick="logout();" data-options="iconCls:'icon-loginout'"><spring:message code="safety.exit"/></div>
					<!-- <div data-options="iconCls:'icon-edit'">  
				        <span>更换皮肤</span>  
				        <div style="width:150px;">  
				            <div onclick="javascript:changeTheme('default')">default</div>  
				            <div onclick="javascript:changeTheme('gray')">gray</div>  
				            <div onclick="javascript:changeTheme('sunny')">sunny</div>  
				            <div onclick="javascript:changeTheme('dark-hive')">dark-hive</div>  
				            <div onclick="javascript:changeTheme('pepper-grinder')">pepper-grinder</div>  
				            <div onclick="javascript:changeTheme('cupertino')">cupertino</div>  
				        </div>  
				    </div>  --> 
				</div>
				</span>
<!-- 				<span style="float: right; padding-right: 20px;">欢迎 <b> -->
<%-- 					${sessionInfo.name}</b>&nbsp;&nbsp;  --%>
<!-- 					<a href="javascript:void(0)" onclick="editUserPwd()" style="color: #fff;cursor: pointer;text-decoration: none;">修改密码</a>&nbsp;&nbsp; -->
<!-- 					<a href="javascript:void(0)" onclick="logout()" style="color: #fff;cursor: pointer;text-decoration: none;">安全退出</a> -->
<!-- 	        	&nbsp;&nbsp;&nbsp;&nbsp; -->
<!-- 	    		</span> -->
	    		<span class="header"></span>
    		</div>
		</div>
		<div data-options="region:'west',split:true" title="<spring:message code="main.navigation"/>" style="width: 160px; overflow: hidden;overflow-y:auto;">
			<div class="well well-small" style="padding: 5px 5px 5px 5px;">
				<ul id="layout_west_tree"></ul>
			</div>
		</div>
		<div data-options="region:'center'" style="overflow: hidden;">
			<div id="index_tabs" style="overflow: hidden;">
				<div title="<spring:message code="home.page"/>" data-options="border:false" style="overflow: hidden;">
					<div style="padding:10px 0 10px 10px">
						<h2><spring:message code="system.introduce"/></h2>
						<div class="light-info">
							<div class="light-tip icon-tip"></div>
							<div><spring:message code="sales.management.platform"/>。</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div id="mm" class="easyui-menu" style="width: 150px;">
			 <div id="mm-tabclose" name="6">
			            刷新</div>
			 <div id="Div1" name="1">
			            关闭</div>
			  <div id="mm-tabcloseall" name="2">
			            全部关闭</div>
			  <div id="mm-tabcloseother" name="3">
			            除此之外全部关闭</div>
			  <div class="menu-sep">
			        </div>
			   <div id="mm-tabcloseright" name="4">
			            当前页右侧全部关闭</div>
			   <div id="mm-tabcloseleft" name="5">
			            当前页左侧全部关闭</div>
		</div>
		<div data-options="region:'south',border:false" style="height: 30px;line-height:30px; overflow: hidden;text-align: center;background-color: #eee" >版权所有@帅哥/${sessionInfo.ip} </div>
		<div data-options="region:'east',split:'true'" title="<spring:message code="auxiliary.navigation"/>" style="width: 200px; overflow: hidden;overflow-y:auto;">
			<div id="cc" class="easyui-calendar" style="width:194px;height:180px;" data-options="border:false"></div>
		</div>
	</div>
	<!--[if lte IE 7]>
	<div id="ie6-warning"><p>您正在使用 低版本浏览器，在本页面可能会导致部分功能无法使用。建议您升级到 <a href="http://www.microsoft.com/china/windows/internet-explorer/" target="_blank">Internet Explorer 8</a> 或以下浏览器：
	<a href="http://www.mozillaonline.com/" target="_blank">Firefox</a> / <a href="http://www.google.com/chrome/?hl=zh-CN" target="_blank">Chrome</a> / <a href="http://www.apple.com.cn/safari/" target="_blank">Safari</a> / <a href="http://www.operachina.com/" target="_blank">Opera</a></p></div>
	<![endif]-->
	
	<style>
		/*ie6提示*/
		#ie6-warning{width:100%;position:absolute;top:0;left:0;background:#fae692;padding:5px 0;font-size:12px}
		#ie6-warning p{width:960px;margin:0 auto;}
	</style>
</body>
</html>