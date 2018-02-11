<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<jsp:include page="../inc.jsp"></jsp:include>
<meta http-equiv="X-UA-Compatible" content="edge" />
<c:if test="${fn:contains(sessionInfo.resourceList, '/user/edit')}">
	<script type="text/javascript">
		$.canEdit = true;
	</script>
</c:if>
<c:if test="${fn:contains(sessionInfo.resourceList, '/user/delete')}">
	<script type="text/javascript">
		$.canDelete = true;
	</script>
</c:if>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>用户管理</title>
<script type="text/javascript">
	var dataGrid;
	var organizationTree;
	$(function() {

		organizationTree = $('#organizationTree').tree({
			url : '${ctx}/organization/tree',
			parentField : 'pid',
			lines : true,
			onClick : function(node) {
				dataGrid.datagrid('load', {
					organizationId : node.id
				});
			}
		});

		dataGrid = $('#dataGrid').datagrid({
			url : '${ctx}/user/dataGrid',
			fit : true,
			striped : true,
			rownumbers : true,
			pagination : true,
			singleSelect : false,
			idField : 'id',
			sortName : 'createdatetime',
			sortOrder : 'asc',
			pageSize : 50,
			pageList : [ 10, 20, 30, 40, 50, 100, 200, 300, 400, 500 ],
			columns : [ [
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
				}, */
				
				{
					width : '80',
					title : '登录名',
					field : 'loginname',
					align : 'center',
					sortable : true
				}, {
					width : '80',
					title : '姓名',
					field : 'name',
					align : 'center',
					sortable : true
				}, {
					width : '120',
					title : '部门ID',
					field : 'organizationId',
					hidden : true
				}, {
					width : '160',
					title : '所属部门',
					align : 'center',
					field : 'organizationName'
				}, {
					width : '40',
					title : '性别',
					field : 'sex',
					sortable : true,
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
					field : 'age',
					align : 'center',
					sortable : true
				}, {
					width : '90',
					title : '电话',
					field : 'phone',
					align : 'center',
					sortable : true
				}, {
					width : '100',
					title : '用户类型',
					field : 'usertype',
					sortable : true,
					align : 'center',
					formatter : function(value, row, index) {
						if (value == 0) {
							return "管理员";
						} else if (value == 1) {
							return "用户";
						} else if(value == 2){
							return "超级管理员"
						}
						return "未知类型";
					}
				}, {
					width : '60',
					title : '是否默认',
					field : 'isdefault',
					sortable : true,
					align : 'center',
					formatter : function(value, row, index) {
						switch (value) {
						case 0:
							return '默认';
						case 1:
							return '否';
						}
					}
				}, {
					width : '60',
					title : '状态',
					field : 'state',
					sortable : true,
					align : 'center',
					formatter : function(value, row, index) {
						switch (value) {
						case 0:
							return '正常';
						case 1:
							return '停用';
						}
					}
				}, {
					width : '130',
					title : '创建时间',
					field : 'createdatetime',
					align : 'center',
					sortable : true,
					formatter : function (value,row,index){
						return formatterDate(value);
					}
				}, {
					field : 'action',
					title : '操作',
					width : 100,
					align : 'center',
					formatter : function(value, row, index) {
						var str = '';
						if (row.isdefault != 0) {
							if ($.canEdit) {
								str += '&nbsp;&nbsp;&nbsp;&nbsp;';
								str += $.formatString('<a href="javascript:void(0)" onclick="editFun(\'{0}\');" >编辑</a>', row.id);
							}
							if ($.canDelete) {
								str += '&nbsp;&nbsp;&nbsp;&nbsp;';
								str += $.formatString('<a href="javascript:void(0)" onclick="deleteFun(\'{0}\');" >删除</a>', row.id);
							}
						}
						return str;
					}
				} ] ],
			toolbar : '#toolbar'
		});
	});

	function sendFun(id){
		window.location.href="${ctx}/msg/talk?to="+id;
	}
	function addFun() {
		parent.$.modalDialog({
			title : '添加',
			width : 500,
			height : 300,
			href : '${ctx}/user/addPage',
			buttons : [ {
				text : '添加',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid; //因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
					var f = parent.$.modalDialog.handler.find('#userAddForm');
					f.submit();
				}
			} ]
		});
	}

	function deleteFun(id) {
		if (id == undefined) { //点击右键菜单才会触发这个
			var rows = dataGrid.datagrid('getSelections');
			id = rows[0].id;
		} else { //点击操作里面的删除图标会触发这个
			dataGrid.datagrid('unselectAll').datagrid('uncheckAll');
		}
		parent.$.messager.confirm('询问', '您是否要删除当前用户？', function(b) {
			if (b) {
				var currentUserId = '${sessionInfo.id}'; /*当前登录用户的ID*/
				if (currentUserId != id) {
					progressLoad();
					$.post('${ctx}/user/delete', {
						id : id
					}, function(result) {
						if (result.success) {
							parent.$.messager.alert('提示', result.msg, 'info');
							dataGrid.datagrid('reload');
						}
						progressClose();
					}, 'JSON');
				} else {
					parent.$.messager.show({
						title : '提示',
						msg : '不可以删除自己！'
					});
				}
			}
		});
	}
	function exportFun() {
		window.location.href = "${ctx}/user/export";
// 		$.ajax( {    
//          type : "POST",  //定义方法类型（get，post）  
//          url : "${ctx}/user/export",  //对应后台的访问地址：URL  
//          data : {  
         
//          },  //往后台传送的参数  
//          dataType : "json",//传参数的类型  
//          success : function(data) {  
//                 if(data){  
//                     if(data.success){  
//                         $.messager.alert('提示', data.msg, 'info', function(){  
//                             $('#t_student').datagrid('reload');  
//                         });  
//                     }else{  
//                         $.messager.alert('提示',data.msg, 'error');  
//                     }  
//                 }  
//             },  
//             error : function(data) {  
//                 $.messager.alert('警告',data.msg, 'error');  
//             }  
//         });
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
			height : 300,
			href : '${ctx}/user/editPage?id=' + id,
			buttons : [ {
				text : '编辑',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid; //因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
					var f = parent.$.modalDialog.handler.find('#userEditForm');
					f.submit();
				}
			} ]
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
		style="height: 60px; overflow: hidden;background-color: #F0F0F0">
		<div>
			<form id="searchForm">
				<table>
					<tr>
						<td>姓名:</td>
						<td><input name="name" id="name" placeholder="请输入用户姓名" /></td>
						<td>创建时间:</td>
						<td><input name="createdatetimeStart" placeholder="点击选择时间"
							onclick="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd HH:mm:ss'})"
							readonly="readonly" /></td>
						<td>至</td>
						<td><input name="createdatetimeEnd" placeholder="点击选择时间"
							onclick="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd HH:mm:ss'})"
							readonly="readonly" /></td>
						<td><c:if
								test="${fn:contains(sessionInfo.resourceList, '/user/dataGrid')}">
								<c:if
									test="${fn:contains(sessionInfo.resourceList, '/user/dataGrid/0')}">
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
	<div data-options="region:'center',border:true,title:'用户列表'">
		<table id="dataGrid" data-options="fit:true,border:false"></table>
	</div>
	<div data-options="region:'west',border:true,split:false,title:'组织机构'"
		style="width:180px;overflow: hidden; ">
		<ul id="organizationTree"
			style="width:160px;margin: 10px 10px 10px 10px">
		</ul>
	</div>
	<div id="toolbar" style="display: none;">
		<c:if test="${fn:contains(sessionInfo.resourceList, '/user/add')}">
			<c:if test="${fn:contains(sessionInfo.resourceList, '/user/add/0')}">
				<a onclick="addFun();" href="javascript:void(0);"
					class="easyui-linkbutton"
					data-options="plain:true,iconCls:'icon-add'">添加</a>
			</c:if>
		</c:if>
		<c:if test="${fn:contains(sessionInfo.resourceList, '/user/add')}">
			<c:if test="${fn:contains(sessionInfo.resourceList, '/user/add/0')}">
				<a onclick="exportFun();" href="javascript:void(0);"
					class="easyui-linkbutton"
					data-options="plain:true,iconCls:'icon-export'">导出</a>
			</c:if>
		</c:if>
	</div>
</body>
</html>