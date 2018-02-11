<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%-- 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%> --%>
<%-- <jsp:include page="../inc.jsp"></jsp:include> --%>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<script type="text/javascript">
	$(function() {
		$('#orderAddForm').form({
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
	
	function addRow(){
		var len=$("#list tr").length+1;
		var str="<tr id='appendTo"+len+"'>";
		str+="<td style='width: 71px;text-align: center;'><select id='goodsNameIds"+len+"' name='goodsNameIds' style='width: 90px;' class='easyui-combobox' data-options=\"valueField:'id',textField:'text',url:'${pageContext.request.contextPath}/kind/tree',required:true,editable:false\"></select></td>";
		str+="<td style='width: 71px;text-align: center;'><input id='goodsQtys"+len+"'  name='goodsQtys' onkeyup='cal("+len+")' maxlength='4' class=\"easyui-validatebox\"  style='width: 90px;' required data-options=\"validType:'positiveInteger'\"/></td>";
		str+="<td style='width: 71px;text-align: center;'><select id='goodsUnitIds"+len+"' name='goodsUnitIds' style='width: 90px;' class='easyui-combobox' data-options=\"valueField:'id',textField:'text',url:'${pageContext.request.contextPath}/unit/tree',required:true,editable:false\"></select></td>";
		str+="<td style='width: 71px;text-align: center;'><input id='goodsPrices"+len+"' name='goodsPrices' onkeyup='cal("+len+")' maxlength='4' class='easyui-validatebox'  style='width: 90px;' required data-options=\"validType:'number'\"/></td>";
		str+="<td style='width: 71px;text-align: center;'><input id='goodsSums"+len+"' name='goodsSums' class='easyui-textbox'  readonly='readonly' style='width: 90px;' required /></td>";
		str+="<td style='width: 71px;text-align: center;'><a href='javascript:;' onclick='deleteRow(this)' style='color: blue;'>删除</a></td>";
		str+="</tr>";
		if(len >21){
			parent.$.messager.alert('提示', "订单明细已上限，请勿再添加！", 'info');
			return;
		}
		$("#list").append(str);
		$.parser.parse("#appendTo"+len);
		
	}
	
	function deleteRow(obj){
		 $(obj).parent().parent().remove(); 
	}
	
	function cal(obj){
	/* 	$('#goodsQtys'+obj).textbox({
			     inputEvents:$.extend({},$.fn.textbox.defaults.inputEvents,{
			         keyup:function(e){
			             alert("sss");
			         }
			     })
		}); */
			
		var val1=$("#goodsQtys"+obj).val();
		var val2=$("#goodsPrices"+obj).val();
		$("#goodsSums"+obj).textbox("setValue", "");
		if(val1!="" && val2!=""){
			var result=(Number(val1*val2)).toFixed(2);
// 			var value=result.replace("(?<=\\d)(?=(?:\\d{3})+$)", ",");
			var value=result.replace(/(\d{1,2})(?=(\d{3})+\.)/g, '$1,');
			$("#goodsSums"+obj).textbox("setValue", value);
		}
	}

	function selectCustomer(){
		$('#dd').dialog({
		    title: '选择客户',
		    width: 250,
		    height: 315,
		    closed: false,
		    cache: false,
		    href : '',
		    modal: true
		});
	}
</script>

<script type="text/javascript">
$(function () {
	$('#reciever').combobox({  
	    prompt:'输入关键字检索',  
	    required:true,  
	    url:'${ctx}/customer/likeSearch',  
	    editable:true,  
	    hasDownArrow:false,  
	    filter: function(q, row){
	        var opts = $(this).combobox('options');
	        debugger;
	        return row[opts.textField].indexOf(q) == 0;  
	    }  
	}); 
});

</script>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title="" style="overflow: auto;padding: 3px;">
		<form id="orderAddForm" method="post" enctype="multipart/form-data">
			<table class="grid" id="list">
				<tr>
					<td class="names">收货人:</td>
					<td class="" colspan="5">
						<input class="easyui-combobox" name="reciever" id="reciever" data-options="valueField:'id',textField:'custName',panelHeight:'auto',panelMaxHeight:200,panelMinHeight:100,validType:'chineseName'"  style="width: 120px;"/> 
					</td>
				</tr>
				<tr>
					<td class="names">联系方式:</td>
					<td class="" colspan="5">
						<input name="recieverPhone" class="easyui-numberbox" data-options="width:'120',required:true,prompt:'请正确输入联系方式',validType:'telNum'" value="">
					</td>
				</tr>
				<tr>
					<td class="names">送货地址:</td>
					<td class="texts" colspan="5">
						<input name="deliveryAddress" class="easyui-textbox" data-options="width:'100%',required:true,prompt:'请正确输入送货地址',validType:'maxLength[50]'" >
					</td>
				</tr>
				<tr>
					<td class="names">送货日期:</td>
					<td colspan="5">
						<input class="easyui-datetimebox" name="orderDate" required/>
					</td>
				</tr>
				<tr>
					<td class="subNames">名称</td>
					<td class="subNames">数量</td>
					<td class="subNames">单位</td>
					<td class="subNames">单价</td>
					<td class="subNames">金额</td>
					<td class="subNames">操作</td>
				</tr>
				<tr id="copy">
					<td style="width: 71px;text-align: center;">
						<select id="goodsNameIds2" name="goodsNameIds" style="width: 90px;" class="easyui-combobox" data-options="valueField:'id',textField:'text',url:'${pageContext.request.contextPath}/kind/tree',required:true,validType:'selectValueRequired',editable:false"></select>
					</td>
					<td style="width: 71px;text-align: center;">
						<input id="goodsQtys2" name="goodsQtys" onkeyup="cal(2)" class="easyui-validatebox" maxlength="4" style="width: 90px;"  required data-options="validType:'positiveInteger'"/>
					</td>
					<td style="width: 71px;text-align: center;">
						<select id="goodsUnitIds2" name="goodsUnitIds" style="width: 90px;" class="easyui-combobox" data-options="valueField:'id',textField:'text',url:'${pageContext.request.contextPath}/unit/tree',required:true,editable:false"></select>
					</td>
					<td style="width: 71px;text-align: center;">
						<input id="goodsPrices2" name="goodsPrices" onkeyup="cal(2)" class="easyui-validatebox" maxlength="4" style="width: 90px;" required data-options="validType:'number'"/>
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
<div id="dd">
</div>
