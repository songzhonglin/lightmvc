<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix='fmt' uri="http://java.sun.com/jsp/jstl/fmt" %> 
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<script type="text/javascript">
</script>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title="" style="overflow: hidden;padding: 3px;">
		<table class="grid">
			<tr>
				<td style="width: 130px;">品类编码:</td>
				<td style="width: 130px;">${category.categoryCode}</td>
				<td style="width: 130px;">品类名称:</td>
				<td style="width: 130px;">${category.categoryName}</td>
			</tr>
			<tr>
				<td>创建人</td>
				<td>${category.creater}</td>
				<td>创建时间:</td>
				<td>
					<fmt:formatDate value="${category.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
			</tr>
			<tr>
				<td>备注:</td>
				<td colspan="3">${category.remark}</td>
			</tr>
		</table>
	</div>
</div>