<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix='fmt' uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<script type="text/javascript">
	$(function() {
		$('#orderBalanceDetailForm').form({
			url : '${pageContext.request.contextPath}/order/add',
			onSubmit : function() {
				progressLoad();
				var isValid = $(this).form('validate');
				if (!isValid) {
					progressClose();
				}
				return isValid;
			},
			success : function(result) {
				progressClose();
				result = $.parseJSON(result);
				if (result.success) {
					parent.$.messager.alert('提示', result.msg, 'info');
					parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
					parent.$.modalDialog.handler.dialog('close');
				} else {
					parent.$.messager.alert('错误', result.msg, 'error');
				}
			}
		});
	});
	function submitForm(){
		
		$('#orderBalanceDetailForm').form('submit',{
			url : '${pageContext.request.contextPath}/order/add',
			onSubmit : function() {
				progressLoad();
				var isValid = $(this).form('validate');
				if (!isValid) {
					progressClose();
				}
				return isValid;
			},
			success : function(result) {
				progressClose();
				result = $.parseJSON(result);
				if (result.success) {
					$.messager.alert('提示', result.msg, 'info');
// 					parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
// 					parent.$.modalDialog.handler.dialog('close');
					window.close();
				} else {
					$.messager.alert('错误', result.msg, 'error');
					top.d_close(); 
// 					top.close();
// 					window.close();
// 					parent.$.modalDialog.handler.dialog('close');
// 					$(window.parent.document).find('#orderBalanceForm').dialog('close'); 
				}
			}
		});
	}
</script>
<div id="dt" class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title=""
		style="overflow: auto; padding: 3px;">
		<form id="orderBalanceDetailForm" method="post" enctype="multipart/form-data">
			<table class="grid" id="list">
							<tr>
								<td style="width: 71px; text-align: center;background-color: #F2F2F2;">名称:</td>
								<td style="width: 71px; text-align: center;">
									${orderDetail.goodsName}
								</td>
							</tr>
							<tr>
								<td style="width: 71px; text-align: center;background-color: #F2F2F2;">数量:</td>
								<td style="width: 71px; text-align: center;">
									${orderDetail.goodsQty}&nbsp;${orderDetail.goodsUnit}
								</td>
							</tr>
							<tr >
								<td style="width: 71px; text-align: center;background-color: #F2F2F2;">单价:</td>
								<td style="width: 71px; text-align: center;">
									￥${orderDetail.goodsPrice }/${orderDetail.goodsUnit}
								</td>
							</tr>
							<tr >
								<td style="width: 71px; text-align: center;background-color: #F2F2F2;">金额:</td>
								<td style="width: 71px; text-align: center;">
									￥${orderDetail.goodsSum }
								</td>
							</tr>
							<tr>
								<td style="width: 71px; text-align: center;background-color: #F2F2F2;">结算金额:</td>
								<td style="width: 71px; text-align: center;">
									<input id="cleanPrice" name="cleanPrice" class="easyui-textbox" style="width: 91px;" required/>
								</td>
							</tr>
							<tr >
								<td style="width: 71px; text-align: center;background-color: #F2F2F2;">结算方式:</td>
								<td style="width: 71px; text-align: center;">
									<select id="cleanWay" class="easyui-combobox" name="cleanWay" data-options="required:true" style="width:91px;">
									    <option value=""></option>
									    <option value="1">微信支付</option>
									    <option value="2">支付宝支付</option>
									    <option value="3">现金支付</option>
									    <option value="4">打卡支付</option>
									</select>
								</td>
							</tr>
							<tr>
								<td style="width: 71px; text-align: center;background-color: #F2F2F2;">结算日期:</td>
								<td style="width: 135px; text-align: center;">
									<input class="easyui-datetimebox" name="orderDate" required style="width: 91px;"/>
								</td>
							</tr>
			</table>
		</form>
		<div id="toolbar" class="datagrid-toolbar" style="text-align:right;padding:5px">
	    	<a href="javascript:void(0)" class="easyui-linkbutton" onclick="submitForm()">结算</a>
	    </div>
	</div>
</div>
