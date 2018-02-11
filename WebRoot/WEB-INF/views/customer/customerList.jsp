<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="../inc.jsp"></jsp:include>
<meta http-equiv="X-UA-Compatible" content="edge" />
<c:if test="${fn:contains(sessionInfo.resourceList, '/customer/edit')}">
	<script type="text/javascript">
		$.canEdit = true;
	</script>
</c:if>
<c:if test="${fn:contains(sessionInfo.resourceList, '/customer/delete')}">
	<script type="text/javascript">
		$.canDelete = true;
	</script>
</c:if>
<c:if test="${fn:contains(sessionInfo.resourceList, '/customer/view')}">
	<script type="text/javascript">
		$.canView = true;
	</script>
</c:if>

<title>用户管理</title>
	<script type="text/javascript">
	var dataGrid;
	$(function() {
		dataGrid = $('#dataGrid').datagrid({
			url : '${ctx}' + '/customer/dataGrid',
			striped : true,
			rownumbers : true,
			pagination : true,
			singleSelect : false,
			idField : 'id',
			sortName : 'id',
			sortOrder : 'asc',
			pageSize : 50,
			pageList : [ 10, 20, 30, 40, 50, 100, 200, 300, 400, 500 ],
			frozenColumns : [ [ 
			{
				width : '45',
				title : '',
				field : 'ck',
				checkbox : true
			},
			/* {
				width : '45',
				title : '序号',
				field : 'id',
				align : 'center',
				sortable : true
			},  */
			{
				width : '80',
				title : '客户名称',
				field : 'custName',
				align : 'center',
				sortable : false
			} , {
				width : '40',
				title : '性别',
				field : 'custSex',
				align : 'center',
				sortable : false,
				align : 'center',
				formatter : function(value, row, index) {
					switch (value) {
					case 0:
						return '男';
					case 1:
						return '女';
					}
				}
			}, {
				width : '40',
				title : '年龄',
				field : 'custAge',
				align : 'center',
				sortable : false
			},{
				width : '90',
				title : '联系方式',
				field : 'custPhone',
				align : 'center',
				sortable : false
			},
			{
				width : '100',
				title : '微信号',
				field : 'custWebchat',
				align : 'center',
				sortable : false
			},
			{
				width : '150',
				title : 'QQ号',
				field : 'custQq',
				align : 'center',
				sortable : false
			},
			{
				width : '150',
				title : '地址',
				field : 'custAddress',
				align : 'center',
				sortable : false
			},
			 {
				width : '200',
				title : '备注',
				field : 'remark'
			} , {
				field : 'action',
				title : '操作',
				align : 'center',
				width : 120,
				formatter : function(value, row, index) {
					var str = '';
						if ($.canView) {
							str += $.formatString('<a href="javascript:void(0)" onclick="viewFun(\'{0}\');" >查看</a>', row.id);
						}
						if ($.canEdit) {
							str += '&nbsp;&nbsp;&nbsp;&nbsp;';
							str += $.formatString('<a href="javascript:void(0)" onclick="editFun(\'{0}\');" >编辑</a>', row.id);
						}
						if ($.canDelete) {
							str += '&nbsp;&nbsp;&nbsp;&nbsp;';
							str += $.formatString('<a href="javascript:void(0)" onclick="deleteFun(\'{0}\');" >删除</a>', row.id);
						}
					return str;
				}
			} ] ],
			onLoadSuccess:function(data){  
		        //if(data.total > 0) return;  
		        //$(this).datagrid('appendRow', { id: '<div style="text-align:center;color:red">没有相关记录！</div>' }).datagrid('mergeCells', { index: 0, field: 'id', colspan: 10 });  
		        //隐藏分页导航条，这个需要熟悉datagrid的html结构，直接用jquery操作DOM对象，easyui datagrid没有提供相关方法隐藏导航条  
		        //$(this).closest('div.datagrid-wrap').find('div.datagrid-pager').hide();  
		        //如果通过调用reload方法重新加载数据有数据时显示出分页导航容器  
		        //$(this).closest('div.datagrid-wrap').find('div.datagrid-pager').show();  
		         if (data.total == 0) {
				    var body = $(this).data().datagrid.dc.body1;
				    body.find('table tbody').append('<tr><td width="' + body.width() + '" style="height: 35px; text-align: center;color:red;"><h1>没有相关记录！</h1></td></tr>');
				  }
		    },
			toolbar : '#toolbar'
		});
	});
	
	function addFun() {
		parent.$.modalDialog({
			title : '添加',
			width : 500,
			height : 335,
			href : '${ctx}/customer/addPage',
			buttons : [ {
				text : '添加',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个treeGrid，所以先预定义好
					var f = parent.$.modalDialog.handler.find('#customerAddForm');
					f.submit();
				}
			} ]
		});
	}
	
	function deleteFun(id) {
		if (id == undefined) {//点击右键菜单才会触发这个
			var rows = dataGrid.datagrid('getSelections');
			id = rows[0].id;
		} else {//点击操作里面的删除图标会触发这个
			dataGrid.datagrid('unselectAll').datagrid('uncheckAll');
		}
		parent.$.messager.confirm('询问', '您是否要删除当前客户信息？', function(b) {
			if (b) {
				progressLoad();
				$.post('${ctx}/customer/delete', {
					id : id
				}, function(result) {
					if (result.success) {
						parent.$.messager.alert('提示', result.msg, 'info');
						dataGrid.datagrid('reload');
					}
					progressClose();
				}, 'JSON');
			}
		});
	}
	
	function deleteBtn(){
		var rows = dataGrid.datagrid('getSelections');
		if(rows.length != 1){
		 	$.messager.alert("提示", "请选择其中一行，再删除！","info");
		}else{
			parent.$.messager.confirm('询问', '您是否要删除当前客户信息？', function(b) {
				if (b) {
					progressLoad();
					$.post('${ctx}/customer/delete', {
						id : rows[0].id
					}, function(result) {
						if (result.success) {
							parent.$.messager.alert('提示', result.msg, 'info');
							dataGrid.datagrid('reload');
						}
						progressClose();
					}, 'JSON');
				}
			});
		}
	}
	
	function editBtn(){
		var rows = dataGrid.datagrid('getSelections');
		if(rows.length != 1){
		 	$.messager.alert("提示", "请选择其中一行，再编辑！","info");
		}else{
			parent.$.modalDialog({
			title : '编辑',
			width : 500,
			height : 528,
			href : '${ctx}/customer/editPage?id=' + rows[0].id,
			buttons : [ {
				text : '编辑',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
					var f = parent.$.modalDialog.handler.find('#customerEditForm');
					f.submit();
				}
			} ]
		});
		}
	}
	
	function editFun(id) {
		if (id == undefined) {
			var rows = dataGrid.datagrid('getSelections');
			id = rows[0].id;
		} else {
			dataGrid.datagrid('unselectAll').datagrid('uncheckAll');
		}
		parent.$.modalDialog({
			title : '编辑',
			width : 500,
			height : 528,
			href : '${ctx}/customer/editPage?id=' + id,
			buttons : [ {
				text : '编辑',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
					var f = parent.$.modalDialog.handler.find('#customerEditForm');
					f.submit();
				}
			} ]
		});
	}
	
	function viewFun(id) {
		if (id == undefined) {
			var rows = dataGrid.datagrid('getSelections');
			id = rows[0].id;
		} else {
			dataGrid.datagrid('unselectAll').datagrid('uncheckAll');
		}
		
		parent.$.modalDialog({
			title : '详情',
			width : 535,
			height : 450,
			href : '${ctx}/customer/viewPage?id=' + id
		});
	}
	function exportBtn(){
		var rows = dataGrid.datagrid('getSelections');
		var ids="";
		for(var i=0;i<rows.length;i++){
			var id=rows[i].id;
			ids+=id+",";
		}
		var params = $.serializeObject($('#searchForm'));
		if(ids !=""){
			window.location.href="${ctx}/customer/export?ids="+ids;
		}else{
			var searchForm = $("#searchForm");
			searchForm[0].action="${ctx}/customer/export";
			searchForm.submit();
		}
	 	
	}
	
	function searchFun() {
		dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
	}
	function cleanFun() {
		$('#searchForm input').val('');
		dataGrid.datagrid('load', {});
	}
	
	</script>
</head>
<body class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'north',border:false,title:'过滤条件'"
		style="height: 60px; overflow: hidden;background-color: #F0F0F0">
		<div>
			<form id="searchForm">
				<table>
					<tr>
						<td>客户名称:</td>
						<td><input name="custName" id="custName" class="easyui-textbox" style="width: 110px;" data-options="prompt:'请输入客户名称'"/></td>
						<td>性别:</td>
						<td>
							<select name="custSex" class="easyui-combobox" data-options="width:80,editable:false,panelHeight:'auto'">
								<option value="" selected="selected">--请选择--</option>
								<option value="0">男</option>
								<option value="1">女</option>
							</select>
						</td>
						<td>联系方式:</td>
						<td><input name="custPhone" id="custPhone" class="easyui-textbox" style="width: 110px;" data-options="prompt:'请输入联系方式'"/></td>
						<td>微信号:</td>
						<td><input name="custWebchat" id="custWebchat" class="easyui-textbox" style="width: 110px;" data-options="prompt:'请输入微信号'" /></td>
						<td>QQ号:</td>
						<td><input name="custQq" id="custQq" class="easyui-textbox" style="width: 110px;" data-options="prompt:'请输入QQ号'" /></td>
						<td>地址:</td>
						<td><input name="custAddress" id="custAddress" class="easyui-textbox" style="width: 110px;" data-options="prompt:'请输入地址'" /></td>
						<td>备注:</td>
						<td><input name="remark" id=""remark"" class="easyui-textbox" style="width: 110px;" data-options="prompt:'请输入备注'" /></td>
						<td><c:if
								test="${fn:contains(sessionInfo.resourceList, '/customer/dataGrid')}">
								<c:if
									test="${fn:contains(sessionInfo.resourceList, '/customer/dataGrid/0')}">
									<a href="javascript:void(0);" class="easyui-linkbutton"
										data-options="iconCls:'icon-search',plain:true"
										onclick="searchFun();">查询</a>
								</c:if>
							</c:if> <a href="javascript:void(0);" class="easyui-linkbutton"
							data-options="iconCls:'icon-clear',plain:true"
							onclick="cleanFun();">清空</a></td>
					</tr>
				</table>
			</form>
		</div>
	</div>
	<div data-options="region:'center',border:true">
		<table id="dataGrid" data-options="fit:true,border:false"></table>
	</div>
	<div id="toolbar" style="display: none;">
		<c:if test="${fn:contains(sessionInfo.resourceList, '/customer/add')}">
			<c:if test="${fn:contains(sessionInfo.resourceList, '/customer/add/0')}">
				<a onclick="addFun();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-add'">添加</a>
			</c:if>
		</c:if>
		<c:if test="${fn:contains(sessionInfo.resourceList, '/customer/delete')}">
			<c:if test="${fn:contains(sessionInfo.resourceList, '/customer/delete/0')}">
				<a onclick="deleteBtn();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-del'">删除</a>
			</c:if>
		</c:if>
		<c:if test="${fn:contains(sessionInfo.resourceList, '/customer/edit')}">
			<c:if test="${fn:contains(sessionInfo.resourceList, '/customer/edit/0')}">
				<a onclick="editBtn();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-edit'">编辑</a>
			</c:if>
		</c:if>
		<c:if test="${fn:contains(sessionInfo.resourceList, '/customer/export')}">
			<c:if test="${fn:contains(sessionInfo.resourceList, '/customer/export/0')}">
				<a onclick="exportBtn();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-export'">导出</a>
			</c:if>
		</c:if>
		<c:if test="${fn:contains(sessionInfo.resourceList, '/customer/import')}">
			<c:if test="${fn:contains(sessionInfo.resourceList, '/customer/import/0')}">
					<div style="float: right;">
					<form id="questionTypesManage"  method="post" enctype="multipart/form-data">  
		   			<input id="uploadExcel" name="uploadExcel" class="easyui-filebox" style="width:200px" data-options="prompt:'请选择文件...',buttonText:'&nbsp;选&nbsp;择&nbsp;'">  
		     
		       　　		<a href="#" class="easyui-linkbutton" style="" onclick="uploadExcel()" >导入题库</a> 　　     　　　　　      
		  
					</form>
				</div>
				
<!-- 				<a onclick="exportBtn();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-export'">导出</a> -->
			</c:if>
		</c:if>
	</div>
</body>
</html>