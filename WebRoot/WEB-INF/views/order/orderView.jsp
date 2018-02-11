<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix='fmt' uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!-- [jQuery] -->
<%-- <script src="${ctx}/jslib/easyui1.4.2/jquery.min.js" type="text/javascript" charset="utf-8"></script> --%>
<%-- <jsp:include page="../inc.jsp"></jsp:include> --%>
<script type="text/javascript">
function resize(){
    $(".list thead th").each(function(index){
      var width = $(this).width();
      $(".list .outer td:nth-child(" + index + ")").css("width", width);
      $(".list .leaf td:nth-child(" + index + ")").css("width", width);
    });
  }

  resize();
  $(window).resize(resize);
  
  $(".switch").click(function(){
	    if($(this).parents(".outer").is(".open")){
	      $(this).parents(".outer").removeClass("open").next(".inner").removeClass("open");
	    }else{
	      $(this).parents(".outer").addClass("open").next(".inner").addClass("open");
	    }
	  });

	  $("tr.outer, tr.leaf").click(function(){
	    $("tr.focus").removeClass("focus");
	    $(this).addClass("focus");
	  });
	
</script>
<script type="text/javascript">
	$(function() {
		$('#orderEditForm').form({
			url : '${pageContext.request.contextPath}/order/edit',
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
	
	function addRow(val,count){
		var len=$("#list tr").length+1;
		var str="<tr id='appendTo"+len+"'>";
// 		str+="<input type=\"hidden\" name='detailIds' />";
		str+="<input type=\"hidden\" name='orderDateId' value='"+val+"'/>";
		str+="<td style='width: 71px;text-align: center;'><select id='goodsNameIds"+len+"' name='goodsNameIds' style='width: 90px;' class='easyui-combobox' data-options=\"valueField:'id',textField:'text',url:'${ctx}/kind/tree',required:true\"></select></td>";
		str+="<td style='width: 71px;text-align: center;'><input id='goodsQtys"+len+"'  name='goodsQtys' class='easyui-textbox'  style='width: 90px;' required /></td>";
		str+="<td style='width: 71px;text-align: center;'><select id='goodsUnitIds"+len+"' name='goodsUnitIds' style='width: 90px;' class='easyui-combobox' data-options=\"valueField:'id',textField:'text',url:'${ctx}/unit/tree',required:true\"></select></td>";
		str+="<td style='width: 71px;text-align: center;'><input id='goodsPrices"+len+"' name='goodsPrices' class='easyui-textbox'  style='width: 90px;' required /></td>";
		str+="<td style='width: 71px;text-align: center;'><input id='goodsSums"+len+"' name='goodsSums' class='easyui-textbox'  readonly='readonly' style='width: 90px;' required /></td>";
		str+="<td style='width: 71px;text-align: center;'><a href='javascript:;' onclick='cal("+len+")' style='color: blue;'>合计</a>&nbsp;<a href=\"javascript:;\" onclick=\"addRow("+val+","+len+")\" style=\"color: blue;\">添加</a>&nbsp;<a href='javascript:;' onclick='deleteRow(this)' style='color: blue;'>删除</a></td>";
		str+="</tr>";
		$("#appendTo"+count).after(str);
		$.parser.parse("#appendTo"+len);
	}
	function getRowObj(obj)
		{  
		var i = 0;   
		while(obj.tagName.toLowerCase() != "tr")
		{   
		obj = obj.parentNode;    
		if(obj.tagName.toLowerCase() == "table")
			return null;   
		}   
		return obj;
	}
	
	function deleteRow(obj){
		 $(obj).parent().parent().remove(); 
	}
	
	function cal(obj){
		var val1=$("#goodsQtys"+obj).val();
		var val2=$("#goodsPrices"+obj).val();
		if(val1!="" && val2!=""){
			var result=parseFloat(val1)*parseFloat(val2);
			$("#goodsSums"+obj).textbox("setValue", result);
		}
	}
	
	function viewOrderDetai(id){
		$('#dd').dialog({
		    title: '明细详情',
		    width: 250,
		    height: 315,
		    closed: false,
		    cache: false,
		    href : '${pageContext.request.contextPath}/order/viewDetailPage?id=' + id,
		    modal: true
		});
		
	}
	
	function viewOrderBalanceRecord(id){
		$('#record').dialog({
		    title: '订单结算记录',
		    width: 700,
		    height: 315,
		    closed: false,
		    cache: false,
		    href : '${pageContext.request.contextPath}/orderBalance/viewBalanceRecordPage?id=' + id,
		    modal: true
		});
		
	}
	
	function show_and_hide_tr(tb_id, obj) {
        $("#" + tb_id).find("tr").each(function(i) {
            i > 0 ? (this.style.display == "none" ? this.style.display = "" : this.style.display = "none") : ($(this).next().css("display") == "none" ? (obj.value = "折叠") : (obj.value = "展开"));
        });
    }
	
</script>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title="" id="printAreaView"
		style="overflow: auto; padding: 3px;">
		<form id="orderEditForm" method="post" enctype="multipart/form-data">
			<input name="id" type="hidden" value="${order.id}">
			<table class="grid">
				<tr>
					<td class="names">订单号:</td>
					<td class="texts">
						<a href="javascript:;" onclick="viewOrderBalanceRecord(${order.id})" style="color: blue;">${order.orderCode}</a>
					</td>
					<td class="names">
						未付款:
					</td>
					<td class="texts" style=" color: red;">
							￥${order.notPayment}
					</td>
				</tr>
				<tr>
					<td class="names">收货人:</td>
					<td class="texts">
						${order.reciever}
					</td>
					<td class="names">
						已付款:
					</td>
					<td class="texts">
						￥${order.payment}
					</td>
				</tr>
				<tr>
					<td class="names">联系方式:</td>
					<td class="texts">
						${order.recieverPhone}
					</td>
					<td class="names">
						总计价格:
					</td>
					<td class="texts">
						<c:if test="${order.totalPrice !=null}">
							￥${order.totalPrice}
						</c:if>
					</td>
				</tr>
				<tr>
					<td class="names">结算状态:</td>
					<td class="texts">
						<c:if test="${order.cleanStatus eq 0}">
							未结算
						</c:if>
						<c:if test="${order.cleanStatus eq 1}">
							全部结算
						</c:if>
						<c:if test="${order.cleanStatus eq 2}">
							部分结算
						</c:if>
					</td>
					<td class="names">结算时间:</td>
					<td class="texts">
						<fmt:formatDate value="${order.cleanDate}" pattern="yyyy-MM-dd HH:mm:ss"/> 
					</td>
					
				</tr>
				<tr>
					<td class="names">支付方式:</td>
					<td class="texts">
						<c:if test="${order.paymentWay eq 0 }">
							
						</c:if>
						<c:if test="${order.paymentWay eq 1 }">
							微信支付
						</c:if>
						<c:if test="${order.paymentWay eq 2 }">
							支付宝支付
						</c:if>
						<c:if test="${order.paymentWay eq 3 }">
							现金支付
						</c:if>
						<c:if test="${order.paymentWay eq 4 }">
							打卡支付
						</c:if>
					</td>
					<td class="names">支付时间:</td>
					<td class="texts">
						<fmt:formatDate value="${order.paymentDate}" pattern="yyyy-MM-dd HH:mm:ss"/> 
					</td>
					
				</tr>
				<tr>
					<td class="names">创建人:</td>
					<td class="texts">
						${order.creater}
					</td>
					<td class="names">创建时间:</td>
					<td class="texts">
						<fmt:formatDate value="${order.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/> 
					</td>
				</tr>
				<tr>
					<td class="names">送货地址:</td>
					<td colspan="3">
						${order.deliveryAddress}
					</td>
				</tr>
				<c:forEach var="orderDates" items="${order.orderDateList}"
					varStatus="state">
					<input name="orderDateIds" type="hidden" value="${orderDates.id}">
					<tr style="background-color: #F2F2F2;" class="outer">
						<td align="center" style="color: #FF00FF;">
							<span class="switch"></span>
							<span class=""></span>
							<span class="name" >送货日期:</span>
						</td>
						<td colspan="0" align="center" style="color: #FF00FF;">
							<fmt:formatDate value="${orderDates.orderDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
						</td>
						<td align="center" style="color: #FF00FF;">
						    合计
						</td>
						<td colspan="0" style="color: #FF00FF;" align="center">
							￥${orderDates.total}
						</td>
					</tr>
					<tr class="inner">
					   <td colspan="4">
					   		 <table class="list">
					   		 	<tr class="outer" style="background-color: #F2F2F2;">
					   		 		   <td align="center"><span class="text-indent"></span><span class="switch"></span><span class=""></span><span class="name">名称</span></td>
					   		 			<td style="width: 140px; text-align: center;">数量</td>
										<td style="width: 140px; text-align: center;">单价</td>
										<td style="width: 140px; text-align: center;">金额</td>
					   		 	</tr>
								<tr class="inner">
								 <td colspan="4">
								 	<table class="list">
								 		<c:forEach var="orderDetail" items="${order.orderDetailList}" varStatus="status">
								 			<c:if test="${orderDates.id eq orderDetail.orderDateId}">
										 		<tr class="leaf">
										 			 <td align="center"><span class="text-indent"></span><span class="text-indent"></span><span class=""></span><span class="">
										 			 </span><span class="name">${orderDetail.goodsName}</span></td>
										 			 <td align="center" style="width: 140px;">
										 			 	${orderDetail.goodsQty}&nbsp;${orderDetail.goodsUnit}
										 			 </td>
										 			 <td align="center" style="width: 140px;">
										 			 	￥${orderDetail.goodsPrice }/${orderDetail.goodsUnit}
										 			 </td>
										 			 <td align="center" style="width: 133px;">
										 			 	￥${orderDetail.goodsSum }
										 			 </td>
										 		</tr>
										 	</c:if>
									 	</c:forEach>
								 	</table>
								 </td>
								</tr>
					   		 </table>
					   </td>
					</tr>
				</c:forEach>
			</table>
		</form>
	</div>
</div>
<div id="dd">
</div>
<div id="record">
</div>
