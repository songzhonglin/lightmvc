package light.mvc.controller.szl;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import light.mvc.controller.base.BaseController;
import light.mvc.framework.constant.GlobalConstant;
import light.mvc.pageModel.base.Grid;
import light.mvc.pageModel.base.Json;
import light.mvc.pageModel.base.PageFilter;
import light.mvc.pageModel.base.SessionInfo;
import light.mvc.pageModel.base.Tree;
import light.mvc.pageModel.szl.OrderUnit;
import light.mvc.service.szl.OrderUnitServiceI;

@Controller
@RequestMapping("/unit")
public class OrderUnitController extends BaseController {
	@Autowired
	private OrderUnitServiceI orderUnitService;

	@RequestMapping("/manager")
	public String manager() {
		return "/unit/unitList";
	}

	@RequestMapping("/dataGrid")
	@ResponseBody
	public Grid dataGrid(OrderUnit orderUnit, PageFilter ph, HttpServletRequest request) {
		SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute(GlobalConstant.SESSION_INFO);
		Grid grid = new Grid();
		grid.setRows(orderUnitService.dataGrid(orderUnit, ph, sessionInfo));
		grid.setTotal(orderUnitService.count(orderUnit, ph, sessionInfo));
		return grid;
	}

	@RequestMapping("/add")
	@ResponseBody
	public Json add(OrderUnit orderUnit, HttpServletRequest request) {
		SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute(GlobalConstant.SESSION_INFO);
		Json j = new Json();
		try {
			orderUnitService.add(sessionInfo, orderUnit);
			j.setSuccess(true);
			j.setMsg("添加成功！");
		} catch (Exception e) {
			j.setMsg(e.getMessage());
		}
		return j;
	}

	@RequestMapping("/delete")
	@ResponseBody
	public Json delete(Long id, HttpServletRequest request) {
		Json j = new Json();
		try {
			orderUnitService.delete(id, request);
			j.setMsg("删除成功！");
			j.setSuccess(true);
		} catch (Exception e) {
			j.setMsg(e.getMessage());
		}
		return j;
	}

	@RequestMapping("/editPage")
	public String editPage(HttpServletRequest request, Long id) {
		OrderUnit r = orderUnitService.get(id);
		request.setAttribute("unit", r);
		return "/unit/unitEdit";
	}

	@RequestMapping("/viewPage")
	public String viewPage(HttpServletRequest request, Long id) {
		OrderUnit r = orderUnitService.get(id);
		request.setAttribute("unit", r);
		return "/unit/unitView";
	}

	@RequestMapping("/edit")
	@ResponseBody
	public Json edit(OrderUnit orderUnit, HttpServletRequest request) {
		Json j = new Json();
		try {
			orderUnitService.edit(orderUnit);
			j.setSuccess(true);
			j.setMsg("编辑成功！");
		} catch (Exception e) {
			j.setMsg(e.getMessage());
		}
		return j;
	}

	@RequestMapping("/tree")
	@ResponseBody
	public List<Tree> tree() {
		return orderUnitService.tree();
	}
}
