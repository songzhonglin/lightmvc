<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="../inc.jsp"></jsp:include>
<meta http-equiv="X-UA-Compatible" content="edge" />
<c:if test="${fn:contains(sessionInfo.resourceList, '/kind/edit')}">
	<script type="text/javascript">
		$.canEdit = true;
	</script>
</c:if>
<c:if test="${fn:contains(sessionInfo.resourceList, '/kind/delete')}">
	<script type="text/javascript">
		$.canDelete = true;
	</script>
</c:if>
<c:if test="${fn:contains(sessionInfo.resourceList, '/kind/view')}">
	<script type="text/javascript">
		$.canView = true;
	</script>
</c:if>
<title>kind管理</title>
	<script type="text/javascript">
	var dataGrid;
	$(function() {
		dataGrid = $('#dataGrid').datagrid({
			url : '${ctx}' + '/kind/dataGrid',
			striped : true,
			rownumbers : true,
			pagination : true,
			singleSelect : true,
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
				title : '编号',
				field : 'id',
				align : 'center',
				sortable : true
			},  */
			{
				width : '80',
				title : '种类编码',
				field : 'kindCode',
				align : 'center',
				sortable : true
			},{
				width : '80',
				title : '种类名称',
				field : 'kindName',
				align : 'center',
				sortable : false
			} , {
				width : '80',
				title : '创建人',
				field : 'creater',
				align : 'center',
				align : 'center'
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
			toolbar : '#toolbar'
		});
	});
	
	function addFun() {
		parent.$.modalDialog({
			title : '添加',
			width : 500,
			height : 230,
			href : '${ctx}/kind/addPage',
			buttons : [ {
				text : '添加',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个treeGrid，所以先预定义好
					var f = parent.$.modalDialog.handler.find('#kindAddForm');
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
		parent.$.messager.confirm('询问', '您是否要删除当前种类信息？', function(b) {
			if (b) {
				progressLoad();
				$.post('${ctx}/kind/delete', {
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
		if(rows.length <= 0){
		 	$.messager.alert("提示", "请选择其中一行，再删除！","info");
		}else{
			parent.$.messager.confirm('询问', '您是否要删除当前种类信息？', function(b) {
				if (b) {
					progressLoad();
					$.post('${ctx}/kind/delete', {
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
		if(rows.length <= 0){
		 	$.messager.alert("提示", "请选择其中一行，再编辑！","info");
		}else{
			parent.$.modalDialog({
			title : '编辑',
			width : 500,
			height : 415,
			href : '${ctx}/kind/editPage?id=' + rows[0].id,
			buttons : [ {
				text : '编辑',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
					var f = parent.$.modalDialog.handler.find('#kindEditForm');
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
			height : 415,
			href : '${ctx}/kind/editPage?id=' + id,
			buttons : [ {
				text : '编辑',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
					var f = parent.$.modalDialog.handler.find('#kindEditForm');
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
			height : 370,
			href : '${ctx}/kind/viewPage?id=' + id
		});
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
		style="height: 60px;background-color: #F0F0F0">
		<div>
			<form id="searchForm">
				<table>
					<tr>
						<td>种类名称:</td>
						<td><input name="kindName" id="kindName" class="easyui-textbox" data-options="prompt:'请输入品类名称'"/></td>
						<td><c:if
								test="${fn:contains(sessionInfo.resourceList, '/kind/dataGrid')}">
								<c:if
									test="${fn:contains(sessionInfo.resourceList, '/kind/dataGrid/0')}">
									<a href="javascript:void(0);" class="easyui-linkbutton"
										data-options="iconCls:'icon-search',plain:true"
										onclick="searchFun();">查询</a>
								</c:if>
							</c:if> <a href="javascript:void(0);" class="easyui-linkbutton"
							data-options="iconCls:'icon-cancel',plain:true"
							onclick="cleanFun();">清空</a></td>
					</tr>
				</table>
			</form>
		</div>
	</div>
	<div data-options="region:'center',border:true">
		<table id="dataGrid" data-options="fit:true,border:false,fitColumns:true"></table>
	</div>
	<div id="toolbar" style="display: none;">
		<c:if test="${fn:contains(sessionInfo.resourceList, '/kind/add')}">
			<c:if test="${fn:contains(sessionInfo.resourceList, '/kind/add/0')}">
				<a onclick="addFun();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-add'">添加</a>
			</c:if>
		</c:if>
		<c:if test="${fn:contains(sessionInfo.resourceList, '/kind/delete')}">
			<c:if test="${fn:contains(sessionInfo.resourceList, '/kind/delete/0')}">
				<a onclick="deleteBtn();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-del'">删除</a>
			</c:if>
		</c:if>
		<c:if test="${fn:contains(sessionInfo.resourceList, '/kind/edit')}">
			<c:if test="${fn:contains(sessionInfo.resourceList, '/kind/edit/0')}">
				<a onclick="editBtn();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-edit'">编辑</a>
			</c:if>
		</c:if>
	</div>
</body>
</html>