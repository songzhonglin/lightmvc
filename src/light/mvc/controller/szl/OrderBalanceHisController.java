package light.mvc.controller.szl;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import light.mvc.controller.base.BaseController;
import light.mvc.pageModel.szl.OrderBalanceHis;
import light.mvc.service.szl.OrderBalanceHisServiceI;

@Controller
@RequestMapping("/orderBalance")
public class OrderBalanceHisController extends BaseController {
	@Autowired
	private OrderBalanceHisServiceI orderBalanceHisServiceI;

	// 补货
	@RequestMapping("/viewBalanceRecordPage")
	public String viewBalanceRecordPage(HttpServletRequest request, Long id) {
		List<OrderBalanceHis> list = orderBalanceHisServiceI.obhList(id);
		request.setAttribute("orderBalance", list);
		return "/order/orderBalanceRecord";
	}

}
