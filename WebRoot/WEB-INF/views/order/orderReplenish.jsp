<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<script type="text/javascript">
	$(function() {
		$('#orderReplenishForm').form({
			url : '${pageContext.request.contextPath}/order/replenish',
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
	
	function addRow(){
		var len=$("#replenishList tr").length+1;
		var str="<tr id='appendTo"+len+"'>";
		str+="<td style='width: 71px;text-align: center;'><select id='goodsNameIds"+len+"' name='goodsNameIds' style='width: 90px;' class='easyui-combobox' data-options=\"valueField:'id',textField:'text',url:'${pageContext.request.contextPath}/kind/tree',required:true,editable:false\"></select></td>";
		str+="<td style='width: 71px;text-align: center;'><input id='goodsQtys"+len+"'  name='goodsQtys' onkeyup='cal("+len+")' class='easyui-validatebox'  style='width: 90px;' required data-options=\"validType:'positiveInteger'\"/></td>";
		str+="<td style='width: 71px;text-align: center;'><select id='goodsUnitIds"+len+"' name='goodsUnitIds' style='width: 90px;' class='easyui-combobox' data-options=\"valueField:'id',textField:'text',url:'${pageContext.request.contextPath}/unit/tree',required:true,editable:false\"></select></td>";
		str+="<td style='width: 71px;text-align: center;'><input id='goodsPrices"+len+"' name='goodsPrices' onkeyup='cal("+len+")' class='easyui-validatebox'  style='width: 90px;' required data-options=\"validType:'number'\"/></td>";
		str+="<td style='width: 71px;text-align: center;'><input id='goodsSums"+len+"' name='goodsSums' class='easyui-textbox'  readonly='readonly' style='width: 90px;' required /></td>";
		str+="<td style='width: 71px;text-align: center;'><a href='javascript:;' onclick='deleteRow(this)' style='color: blue;'>删除</a></td>";
		str+="</tr>";
		if(len >21){
			parent.$.messager.alert('提示', "订单明细已上限，请勿再添加！", 'info');
			return;
		}
		$("#replenishList").append(str);
		$.parser.parse("#appendTo"+len);
		
	}
	
	function deleteRow(obj){
		 $(obj).parent().parent().remove(); 
	}
	
	function cal(obj){
		var val1=$("#goodsQtys"+obj).val();
		var val2=$("#goodsPrices"+obj).val();
		if(val1!="" && val2!=""){
			var result=(Number(val1*val2)).toFixed(2);
// 			var value=result.replace("(?<=\\d)(?=(?:\\d{3})+$)", ",");
			var value=result.replace(/(\d{1,2})(?=(\d{3})+\.)/g, '$1,');
			$("#goodsSums"+obj).textbox("setValue", value);
		}
	}
</script>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title="" style="overflow: auto;padding: 3px;">
		<form id="orderReplenishForm" method="post" enctype="multipart/form-data">
			<input name="id" type="hidden"  value="${order.id}">
			<table class="grid" id="replenishList">
				<tr>
					<td class="names">送货日期:</td>
					<td colspan="6">
						<input class="easyui-datetimebox" name="orderDate" required/>
					</td>
				</tr>
				<tr>
					<td style="width: 71px;text-align: center;background-color: #F2F2F2;">名称</td>
					<td style="width: 71px;text-align: center;background-color: #F2F2F2">数量</td>
					<td style="width: 71px;text-align: center;background-color: #F2F2F2">单位</td>
					<td style="width: 71px;text-align: center;background-color: #F2F2F2">单价</td>
					<td style="width: 71px;text-align: center;background-color: #F2F2F2">金额</td>
					<td style="width: 71px;text-align: center;background-color: #F2F2F2">操作</td>
				</tr>
				<tr>
					<td style="width: 71px;text-align: center;">
						<select id="goodsNameIds2" name="goodsNameIds" style="width: 90px;" class="easyui-combobox" data-options="valueField:'id',textField:'text',url:'${pageContext.request.contextPath}/kind/tree',required:true,editable:false"></select>
					</td>
					<td style="width: 71px;text-align: center;">
						<input id="goodsQtys2" name="goodsQtys" onkeyup="cal(2)" class="easyui-validatebox" style="width: 90px;" required data-options="validType:'positiveInteger'"/>
					</td>
					<td style="width: 71px;text-align: center;">
						<select id="goodsUnitIds2" name="goodsUnitIds" style="width: 90px;" class="easyui-combobox" data-options="valueField:'id',textField:'text',url:'${pageContext.request.contextPath}/unit/tree',required:true,editable:false"></select>
					</td>
					<td style="width: 71px;text-align: center;">
						<input id="goodsPrices2" name="goodsPrices" onkeyup="cal(2)" class="easyui-validatebox" style="width: 90px;" required data-options="validType:'number'"/>
					</td>
					<td style="width: 71px;text-align: center;">
						<input id="goodsSums2" name="goodsSums" class="easyui-textbox"  readonly="readonly" style="width: 90px;" required/>
					</td>
					<td style="width: 71px;text-align: center;"><a href="javascript:;" onclick="addRow()" style="color: blue;">添加</a></td>
				</tr>
			</table>
		</form>
	</div>
</div>
