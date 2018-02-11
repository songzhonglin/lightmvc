package light.mvc.service.szl;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import light.mvc.pageModel.base.PageFilter;
import light.mvc.pageModel.base.SessionInfo;
import light.mvc.pageModel.szl.OrderDetail;

public interface OrderDetailServiceI {
	public List<OrderDetail> dataGrid(OrderDetail orderDetail, PageFilter ph, SessionInfo sessionInfo);

	public Long count(OrderDetail orderDetail, PageFilter ph,SessionInfo sessionInfo);
	
	public void add(SessionInfo sessionInfo, OrderDetail orderDetail);

	public void delete(Long id, HttpServletRequest request);
	
	public void edit(OrderDetail orderDetail);

	public OrderDetail get(Long id);
}
