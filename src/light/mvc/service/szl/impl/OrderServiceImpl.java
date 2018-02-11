package light.mvc.service.szl.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import light.mvc.dao.BaseDaoI;
import light.mvc.model.szl.Tcumstomer;
import light.mvc.model.szl.Tkind;
import light.mvc.model.szl.Torder;
import light.mvc.model.szl.TorderBalanceHis;
import light.mvc.model.szl.TorderDate;
import light.mvc.model.szl.TorderDetail;
import light.mvc.model.szl.TorderUnit;
import light.mvc.pageModel.base.PageFilter;
import light.mvc.pageModel.base.SessionInfo;
import light.mvc.pageModel.szl.Kind;
import light.mvc.pageModel.szl.Order;
import light.mvc.pageModel.szl.OrderDate;
import light.mvc.pageModel.szl.OrderDetail;
import light.mvc.service.szl.OrderServiceI;
import light.mvc.utils.ArithUtil;
import light.mvc.utils.GenerateCode;
import light.mvc.utils.StringUtil;

@Service
public class OrderServiceImpl implements OrderServiceI {
	@Autowired
	private BaseDaoI<Torder> orderDao;
	@Autowired
	private BaseDaoI<TorderDate> orderDateDao;
	@Autowired
	private BaseDaoI<TorderDetail> orderDetailDao;
	@Autowired
	private BaseDaoI<Tkind> kindDao;
	@Autowired
	private BaseDaoI<TorderUnit> orderUnitDao;
	@Autowired
	private BaseDaoI<TorderBalanceHis> orderBalanceHisDao;
	@Autowired
	private BaseDaoI<Tcumstomer> cumstomerDao;

	@Override
	public List<Order> dataGrid(Order order, PageFilter ph, SessionInfo sessionInfo) {
		List<Order> list = new ArrayList<Order>();
		Map<String, Object> params = new HashMap<String, Object>();
		String hql = " from Torder t";
		List<Torder> l = orderDao.find(hql + whereHql(order, params, sessionInfo) + orderHql(ph), params, ph.getPage(),
				ph.getRows());
		for (Torder t : l) {
			Order c = new Order();
			BeanUtils.copyProperties(t, c);
			list.add(c);
		}
		return list;
	}

	@Transactional
	public void add(SessionInfo sessionInfo, Order order) {
		Torder c = new Torder();
		BeanUtils.copyProperties(order, c);
		if (StringUtil.isNumeric(order.getReciever())) {
			c.setReciever(cumstomerDao
					.get("from Tcumstomer t where t.id=" + StringUtil.stringTolnt(order.getReciever())).getCust_name());
		}
		c.setOrderCode(GenerateCode.code());
		c.setCreater(sessionInfo.getName());
		c.setCreateTime(new Date());
		String totalPrice = calTotalPrince(order, c.getTotalPrice());
		c.setTotalPrice(totalPrice);
		c.setNotPayment(totalPrice);
		orderDao.save(c);
		// 添加送货日期
		TorderDate od = new TorderDate();
		od.setOrderId(c.getId().intValue());
		od.setOrderDate(order.getOrderDate());
		od.setCreater(sessionInfo.getName());
		od.setCreateTime(new Date());
		String total = calTotal(order);
		od.setTotal(total);
		orderDateDao.save(od);
		// 添加明细
		for (int i = 0; i < order.getGoodsNameIds().length; i++) {
			String goodsNamesId = order.getGoodsNameIds()[i];
			String goodsQty = order.getGoodsQtys()[i];
			String goodsUnitId = order.getGoodsUnitIds()[i];
			String goodsSum = order.getGoodsSums()[i];
			String goodsPrice = order.getGoodsPrices()[i];
			TorderDetail orderDetail = new TorderDetail();
			orderDetail.setGoodsNameId(Integer.parseInt(goodsNamesId));
			orderDetail.setGoodsName(kindDao.get(Tkind.class, Long.parseLong(goodsNamesId)).getKindName());
			orderDetail.setGoodsQty(goodsQty);
			orderDetail.setGoodsUnitId(Integer.parseInt(goodsUnitId));
			orderDetail.setGoodsUnit(orderUnitDao.get(TorderUnit.class, Long.parseLong(goodsUnitId)).getUnitName());
			orderDetail.setGoodsPrice(goodsPrice);
			orderDetail.setGoodsSum(goodsSum);
			orderDetail.setOrderDateId(od.getId().intValue());
			orderDetail.setCreateTime(new Date());
			orderDetail.setCreater(sessionInfo.getName());
			orderDetailDao.save(orderDetail);
		}
	}

	private String calTotalPrince(Order order, String totalPrice) {
		String sum = "0.00";
		if (totalPrice != null && !"".equals(totalPrice)) {
			sum = ArithUtil.replaceToFloat(totalPrice);
		}
		for (int i = 0; i < order.getGoodsSums().length; i++) {
			String getGoodsSum = ArithUtil.replaceToFloat(order.getGoodsSums()[i]);
			sum = ArithUtil.addMethod(ArithUtil.replaceToFloat(sum), getGoodsSum, 2);
		}
		return sum;
	}

	private String calTotal(Order order) {
		String sum = "0.00";
		for (int i = 0; i < order.getGoodsSums().length; i++) {
			String getGoodsSum = ArithUtil.replaceToFloat(order.getGoodsSums()[i]);
			sum = ArithUtil.addMethod(ArithUtil.replaceToFloat(sum), getGoodsSum, 2);
		}
		return sum;
	}

	@Transactional
	public void delete(Long id, HttpServletRequest request) {
		Torder t = orderDao.get(Torder.class, id);
		List<TorderDate> odList = orderDateDao.find("from TorderDate od where od.orderId=" + t.getId());
		for (TorderDate torderDate : odList) {
			deleteBeforeDetail(torderDate);
			orderDateDao.delete(torderDate);
		}
		orderDao.delete(t);
	}

	@Override
	public Long count(Order order, PageFilter ph, SessionInfo sessionInfo) {
		Map<String, Object> params = new HashMap<String, Object>();
		String hql = " from Torder t ";
		return orderDao.count("select count(*) " + hql + whereHql(order, params, sessionInfo), params);
	}

	private String whereHql(Order order, Map<String, Object> params, SessionInfo sessionInfo) {
		String hql = "";
		if (order != null) {
			hql += " where 1=1 ";
			if (StringUtil.isNotEmpty(order.getOrderCode())) {
				hql += " and t.orderCode like :orderCode";
				params.put("orderCode", "%" + order.getOrderCode() + "%");
			}
			if (StringUtil.isNotEmpty(order.getReciever())) {
				hql += " and t.reciever like :reciever";
				params.put("reciever", "%" + order.getReciever() + "%");
			}
			if (StringUtil.isNotEmpty(order.getRecieverPhone())) {
				hql += " and t.recieverPhone like :recieverPhone";
				params.put("recieverPhone", "%" + order.getRecieverPhone() + "%");
			}
			if (StringUtil.isNotEmpty(order.getCreater())) {
				hql += " and t.creater like :creater";
				params.put("creater", "%" + order.getCreater() + "%");
			}
			if (StringUtil.isNotEmpty(order.getCreateTimeStart())) {
				hql += " and t.createTime >= :createTimeStart";
				params.put("createTimeStart", order.getCreateTimeStart());
			}
			if (StringUtil.isNotEmpty(order.getCreateTimeEnd())) {
				hql += " and t.createTime <= :createTimeEnd";
				params.put("createTimeEnd", order.getCreateTimeEnd());
			}
			if (StringUtil.isNotEmpty(order.getCleanStatus())) {
				hql += " and t.cleanStatus = :cleanStatus";
				params.put("cleanStatus", order.getCleanStatus());
			}
			if (StringUtil.isNotEmpty(order.getPaymentWay())) {
				hql += " and t.paymentWay = :paymentWay";
				params.put("paymentWay", order.getPaymentWay());
			}
		}
		return hql;
	}

	private String orderHql(PageFilter ph) {
		String orderString = "";
		if ((ph.getSort() != null) && (ph.getOrder() != null)) {
			orderString = " order by t." + ph.getSort() + " " + ph.getOrder();
		}
		return orderString;
	}

	@Transactional
	public void edit(Order order, SessionInfo sessionInfo) {
		Torder t = updateBeforeOrder(order);
		String totalPrice = calTotal(order);
		String notPayment = ArithUtil.subMethod(ArithUtil.replaceToFloat(totalPrice),
				ArithUtil.replaceToFloat(t.getPayment()), 2);
		t.setNotPayment(notPayment);
		t.setTotalPrice(totalPrice);
		orderDao.update(t);
		// 更新送货日期明细
		String orderDateIds[] = order.getOrderDateIds();
		for (int i = 0; i < orderDateIds.length; i++) {
			TorderDate od = updateBeforeOrderDate(order, orderDateIds, i);
			deleteBeforeDetail(od);
			updateBeforeDetail(order, sessionInfo, orderDateIds, i, od);
			boolean flag = chkOrderDate(order, orderDateIds, i);
			// 刪除沒有送貨日期的送貨明細
			if (!flag) {
				orderDateDao.delete(od);
			}
		}

	}

	private boolean chkOrderDate(Order order, String[] orderDateIds, int i) {
		boolean flag = false;
		for (int j = 0; j < order.getGoodsNameIds().length; j++) {
			if (orderDateIds[i].equals(order.getOrderDateId()[j])) {
				flag = true;
				break;
			}
		}
		return flag;
	}

	private String calTotal(Order order, String[] orderDateIds, int i) {
		String sum = "0.00";
		for (int j = 0; j < order.getGoodsNameIds().length; j++) {
			if (orderDateIds[i].equals(order.getOrderDateId()[j])) {
				String getGoodsSum = ArithUtil.replaceToFloat(order.getGoodsSums()[j]);
				sum = ArithUtil.addMethod(ArithUtil.replaceToFloat(sum), getGoodsSum, 2);
			}
		}
		return String.valueOf(sum);
	}

	private void updateBeforeDetail(Order order, SessionInfo sessionInfo, String[] orderDateIds, int i, TorderDate od) {
		// 添加明细
		for (int j = 0; j < order.getGoodsNameIds().length; j++) {
			if (orderDateIds[i].equals(order.getOrderDateId()[j])) {
				String goodsNamesId = order.getGoodsNameIds()[j];
				String goodsQty = order.getGoodsQtys()[j];
				String goodsUnitId = order.getGoodsUnitIds()[j];
				String goodsSum = order.getGoodsSums()[j];
				String goodsPrice = order.getGoodsPrices()[j];
				TorderDetail orderDetail = new TorderDetail();
				orderDetail.setGoodsNameId(Integer.parseInt(goodsNamesId));
				orderDetail.setGoodsName(kindDao.get(Tkind.class, Long.parseLong(goodsNamesId)).getKindName());
				orderDetail.setGoodsQty(goodsQty);
				orderDetail.setGoodsUnitId(Integer.parseInt(goodsUnitId));
				orderDetail.setGoodsUnit(orderUnitDao.get(TorderUnit.class, Long.parseLong(goodsUnitId)).getUnitName());
				orderDetail.setGoodsPrice(goodsPrice);
				orderDetail.setGoodsSum(goodsSum);
				orderDetail.setOrderDateId(od.getId().intValue());
				orderDetail.setCreateTime(new Date());
				orderDetail.setCreater(sessionInfo.getName());
				orderDetailDao.save(orderDetail);
			}
		}
	}

	private Torder updateBeforeOrder(Order order) {
		// 更新主单
		Torder t = orderDao.get(Torder.class, order.getId());
		if (StringUtil.isNumeric(order.getReciever())) {
			t.setReciever(cumstomerDao
					.get("from Tcumstomer t where t.id=" + StringUtil.stringTolnt(order.getReciever())).getCust_name());
		} else {
			t.setReciever(order.getReciever());
		}
		t.setRecieverPhone(order.getRecieverPhone());
		t.setDeliveryAddress(order.getDeliveryAddress());
		return t;
	}

	private TorderDate updateBeforeOrderDate(Order order, String[] orderDateIds, int i) {
		TorderDate od = orderDateDao.get(TorderDate.class, Long.parseLong(orderDateIds[i]));
		// 添加送货日期
		od.setOrderDate(order.getOrderDates()[i]);
		od.setTotal(calTotal(order, orderDateIds, i));
		orderDateDao.update(od);
		return od;
	}

	private void deleteBeforeDetail(TorderDate od) {
		// 删除之前的订单明细
		List<TorderDetail> detailList = orderDetailDao.find("from TorderDetail de where de.orderDateId=" + od.getId());
		for (TorderDetail torderDetail : detailList) {
			orderDetailDao.delete(torderDetail);
		}
	}

	@Override
	public Order get(Long id) {
		Torder t = orderDao.get(Torder.class, id);
		Order r = new Order();
		BeanUtils.copyProperties(t, r);
		// String notPayment = calNotPayment(t);
		// r.setNotPayment(notPayment);
		List<TorderDate> orderDates = orderDateDao
				.find("from TorderDate od where od.orderId=" + t.getId() + " order by od.createTime asc");
		r.setOrderDateList(orderDates);
		List<TorderDetail> list = new ArrayList<TorderDetail>();
		List<TorderDetail> resultlist = new ArrayList<TorderDetail>();
		for (TorderDate torderDate : orderDates) {
			List<TorderDetail> detailList = orderDetailDao.find(
					"from TorderDetail de where de.orderDateId=" + torderDate.getId() + " order by de.createTime asc");
			// for (TorderDetail torderDetail : detailList) {
			// TorderDetail td = new TorderDetail();
			// BeanUtils.copyProperties(torderDetail, td);
			// td.setGoodsName(kindDao.get(Tkind.class,
			// torderDetail.getGoodsNameId().longValue()).getKindName());
			// td.setGoodsUnit(orderUnitDao.get(TorderUnit.class,
			// torderDetail.getGoodsUnitId().longValue()).getUnitName());
			// resultlist.add(td);
			// }
			list.addAll(detailList);
		}
		r.setOrderDetailList(list);
		return r;
	}

	private String calNotPayment(Torder t) {
		String price = ArithUtil.addMethod(ArithUtil.replaceToFloat(t.getPayment()),
				ArithUtil.replaceToFloat(t.getActualPrice()), 2);
		String notPayment = ArithUtil.subMethod(ArithUtil.replaceToFloat(t.getTotalPrice()),
				ArithUtil.replaceToFloat(price), 2);
		return notPayment;
	}

	@Transactional
	public void replenish(SessionInfo sessionInfo, Order order) {
		// 更新主单总计价格
		Torder t = orderDao.get(Torder.class, order.getId());
		String totalPrice = calTotalPrince(order, t.getTotalPrice());
		String notPayment = ArithUtil.subMethod(ArithUtil.replaceToFloat(totalPrice),
				ArithUtil.replaceToFloat(t.getPayment()), 2);
		t.setNotPayment(notPayment);
		t.setTotalPrice(totalPrice);
		orderDao.update(t);

		// 添加送货日期
		TorderDate od = new TorderDate();
		od.setOrderId(order.getId().intValue());
		od.setOrderDate(order.getOrderDate());
		od.setCreater(sessionInfo.getName());
		od.setCreateTime(new Date());
		od.setTotal(calTotal(order));
		orderDateDao.save(od);
		// 添加明细
		for (int i = 0; i < order.getGoodsNameIds().length; i++) {
			String goodsNamesId = order.getGoodsNameIds()[i];
			String goodsQty = order.getGoodsQtys()[i];
			String goodsUnitId = order.getGoodsUnitIds()[i];
			String goodsSum = order.getGoodsSums()[i];
			String goodsPrice = order.getGoodsPrices()[i];
			TorderDetail orderDetail = new TorderDetail();
			orderDetail.setGoodsNameId(Integer.parseInt(goodsNamesId));
			orderDetail.setGoodsName(kindDao.get(Tkind.class, Long.parseLong(goodsNamesId)).getKindName());
			orderDetail.setGoodsQty(goodsQty);
			orderDetail.setGoodsUnitId(Integer.parseInt(goodsUnitId));
			orderDetail.setGoodsUnit(orderUnitDao.get(TorderUnit.class, Long.parseLong(goodsUnitId)).getUnitName());
			orderDetail.setGoodsPrice(goodsPrice);
			orderDetail.setGoodsSum(goodsSum);
			orderDetail.setOrderDateId(od.getId().intValue());
			orderDetail.setCreateTime(new Date());
			orderDetail.setCreater(sessionInfo.getName());
			orderDetailDao.save(orderDetail);
		}

	}

	@Transactional
	public void balance(Order order, SessionInfo sessionInfo) {
		// 更新主单
		Torder t = orderDao.get(Torder.class, order.getId());
		String paid = calPaid(t, order);
		t.setPayment(paid);
		t.setPaymentWay(order.getPaymentWay());
		t.setPaymentDate(order.getPaymentDate());
		int result = ArithUtil.compareTo(Double.parseDouble(ArithUtil.replaceToFloat(order.getNotPayment())),
				Double.parseDouble(ArithUtil.replaceToFloat(order.getPayment())));
		if (result == 0) {
			t.setCleanStatus(1);
		} else if (result == 1) {
			t.setCleanStatus(2);
		}
		String notPayment = ArithUtil.subMethod(ArithUtil.replaceToFloat(t.getTotalPrice()),
				ArithUtil.replaceToFloat(paid), 2);
		t.setNotPayment(notPayment);
		t.setCleanDate(order.getCleanDate());
		saveBalanceHist(order, t, sessionInfo);
		orderDao.update(t);
	}

	/**
	 * 订单结算历史
	 * 
	 * @param order
	 * @param
	 * @param sessionInfo
	 */
	private void saveBalanceHist(Order order, Torder t, SessionInfo sessionInfo) {
		TorderBalanceHis o = new TorderBalanceHis();
		o.setPaymentPrice(order.getPayment());
		o.setPaymentWay(order.getPaymentWay());
		o.setPaymentTime(order.getPaymentDate());
		o.setCleanStatus(t.getCleanStatus());
		o.setCleanTime(order.getCleanDate());
		o.setOrderId(order.getId().intValue());
		o.setCreateTime(new Date());
		o.setCreater(sessionInfo.getName());
		orderBalanceHisDao.save(o);

	}

	private String calPaid(Torder t, Order order) {
		return ArithUtil.addMethod(ArithUtil.replaceToFloat(t.getPayment()),
				ArithUtil.replaceToFloat(order.getPayment()), 2);
	}

	@Override
	public boolean isOverPay(Order order, SessionInfo sessionInfo) {
		int result = ArithUtil.compareTo(Double.parseDouble(ArithUtil.replaceToFloat(order.getNotPayment())),
				Double.parseDouble(ArithUtil.replaceToFloat(order.getPayment())));
		if (result == -1) {
			return true;
		}
		return false;
	}

	@Override
	public List<OrderDate> queryByOrderId(Integer orderId) {
		List<TorderDate> l = orderDateDao
				.find("from TorderDate od where od.orderId=" + orderId + " order by od.createTime asc");
		List<OrderDate> lr = new ArrayList<OrderDate>();
		if ((l != null) && (l.size() > 0)) {
			for (TorderDate t : l) {
				OrderDate r = new OrderDate();
				BeanUtils.copyProperties(t, r);
				lr.add(r);
			}
		}
		return lr;
	}

	@Override
	public List<OrderDetail> queryByDateId(Integer dateId) {
		List<TorderDetail> l = orderDetailDao.find(
				"from TorderDetail de where de.orderDateId=" + dateId + " order by de.createTime asc");
		List<OrderDetail> lr = new ArrayList<OrderDetail>();
		if ((l != null) && (l.size() > 0)) {
			for (TorderDetail t : l) {
				OrderDetail r = new OrderDetail();
				BeanUtils.copyProperties(t, r);
				lr.add(r);
			}
		}
		return lr;
	}

}
