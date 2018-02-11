package light.mvc.service.szl.impl;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import light.mvc.dao.BaseDaoI;
import light.mvc.model.szl.TorderDetail;
import light.mvc.pageModel.base.PageFilter;
import light.mvc.pageModel.base.SessionInfo;
import light.mvc.pageModel.szl.OrderDetail;
import light.mvc.service.szl.OrderDetailServiceI;

@Service
public class OrderDetailServiceImpl implements OrderDetailServiceI {
	@Autowired
	private BaseDaoI<TorderDetail> orderDetailDao;

	@Override
	public List<OrderDetail> dataGrid(OrderDetail orderDetail, PageFilter ph, SessionInfo sessionInfo) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Long count(OrderDetail orderDetail, PageFilter ph, SessionInfo sessionInfo) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void add(SessionInfo sessionInfo, OrderDetail orderDetail) {
		// TODO Auto-generated method stub

	}

	@Override
	public void delete(Long id, HttpServletRequest request) {
		// TODO Auto-generated method stub

	}

	@Override
	public void edit(OrderDetail orderDetail) {
		// TODO Auto-generated method stub

	}

	@Override
	public OrderDetail get(Long id) {
		TorderDetail t = orderDetailDao.get(TorderDetail.class, id);
		OrderDetail r = new OrderDetail();
		BeanUtils.copyProperties(t, r);
		return r;
	}

}
