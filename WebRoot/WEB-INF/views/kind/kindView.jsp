<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix='fmt' uri="http://java.sun.com/jsp/jstl/fmt" %> 
<style>
	.container{ position:relative;}
</style>
<style>
	.izImage2{border:0;width:400px;}
	.izViewer2{width:190px;height:180px;position:absolute;left:195px;top:0;display:none; border:1px solid #999;}
	.handle2{display:none;opacity:0.6;filter:alpha(opacity=60);background:#E6EAF3; cursor:crosshair;}
</style>

<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<script type="text/javascript">
</script>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title="" style="overflow: hidden;padding: 3px;">
		<table class="grid">
				<tr>
					<td style="width: 130px;">种类编码:</td>
					<td style="width: 130px;">
						${kind.kindCode}
					</td>
					<td style="width: 130px;">种类名称:</td>
					<td style="width: 130px;">
						${kind.kindName}	
					</td>
				</tr>
				<tr>
					<td>属于品类</td>
					<td>
						${kind.categoryName}
					</td>
				</tr>
				<tr>
					<td>创建人:</td>
					<td>
						${kind.creater}
					</td>
					<td>创建时间:</td>
					<td>
						<fmt:formatDate value="${kind.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
					</td>
				</tr>
				<tr>
					<td>备注:</td>
					<td colspan="3">
						${kind.remark}						
					</textarea></td>
				</tr>
				<tr>
					<td>种类图片</td>
					<td colspan="3">
						<div class="container"> 
							<img id="idImage2" class="izImage2" src="${ctx}/${kind.imgPath}" style="width: 190px;height: 180px;"/>
						<div id="idViewer2" class="izViewer2"></div>
					</div>
					</td>
				</tr>
			</table>
	</div>
</div>

<script>

(function(){

var iz = new ImageZoom( "idImage2", "idViewer2", {
	mode: "handle", handle: "idHandle3", scale: 2, delay: 0
});
iz.reset({ originPic: o.originPic, zoomPic: o.zoomPic });
})()

</script>