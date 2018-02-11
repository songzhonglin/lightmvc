<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix='fmt' uri="http://java.sun.com/jsp/jstl/fmt"%>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title=""
		style="overflow: auto; padding: 3px;">
		<form id="orderEditForm" method="post" enctype="multipart/form-data">
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
							<tr >
								<td style="width: 71px; text-align: center;background-color: #F2F2F2;">结算状态:</td>
								<td style="width: 71px; text-align: center;">
									${orderDetail.cleanStatus == 0 ?"未结算":"已结算"}
								</td>
							</tr>
							<tr>
								<td style="width: 71px; text-align: center;background-color: #F2F2F2;">结算日期:</td>
								<td style="width: 135px; text-align: center;">
									<fmt:formatDate value="${orderDetail.cleanDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
								</td>
							</tr>
							<tr>
								<td style="width: 71px; text-align: center;background-color: #F2F2F2;">结算金额:</td>
								<td style="width: 71px; text-align: center;">
									<c:if test="${orderDetail.cleanPrice != null }">
										￥${orderDetail.cleanPrice }
									</c:if>
									
								</td>
							</tr>
							<tr >
								<td style="width: 71px; text-align: center;background-color: #F2F2F2;">结算方式:</td>
								<td style="width: 71px; text-align: center;">
									<c:if test="${orderDetail.cleanWay eq 0 }">
										未支付
									</c:if>
									<c:if test="${orderDetail.cleanWay eq 1 }">
										微信支付
									</c:if>
									<c:if test="${orderDetail.cleanWay eq 2 }">
										支付宝支付
									</c:if>
									<c:if test="${orderDetail.cleanWay eq 3 }">
										现金支付
									</c:if>
									<c:if test="${orderDetail.cleanWay eq 4 }">
										打卡支付
									</c:if>
								</td>
							</tr>
			</table>
		</form>
	</div>
</div>
