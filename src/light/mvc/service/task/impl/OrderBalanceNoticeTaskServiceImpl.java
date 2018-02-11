package light.mvc.service.task.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import light.mvc.dao.BaseDaoI;
import light.mvc.model.szl.Torder;
import light.mvc.service.email.MailSenderServiceI;
import light.mvc.service.task.OrderBalanceNoticeTaskServiceI;
import light.mvc.utils.DateUtil;

@Service
public class OrderBalanceNoticeTaskServiceImpl implements OrderBalanceNoticeTaskServiceI {
	
	@Autowired
	private MailSenderServiceI mailSenderService; 
	@Autowired
	private BaseDaoI<Torder> orderDao;

	@Override
	public void execute() {
		List<Torder> orderList = orderDao.find("from Torder t where t.cleanStatus !=1");
		Map<String, Object> model =new HashMap<String, Object>();
		for (Torder torder : orderList) {
			Date createTime = torder.getCreateTime();
			Integer days = DateUtil.getDay(createTime);
			if (days > 2) {
				model.put("orderNo", torder.getOrderCode());
				mailSenderService.sendMailWithVelocityTemplate("songzhonglin0616@163.com","结算点单提醒", "mail.vm", model);
			}
		}
	}

}
