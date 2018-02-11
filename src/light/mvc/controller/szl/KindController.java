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
import light.mvc.pageModel.szl.Kind;
import light.mvc.service.szl.KindServiceI;
import light.mvc.utils.UploadUtils;

@Controller
@RequestMapping("/kind")
public class KindController extends BaseController {
	@Autowired
	private KindServiceI kindService;

	@RequestMapping("/manager")
	public String manager() {
		return "/kind/kindList";
	}

	@RequestMapping("/dataGrid")
	@ResponseBody
	public Grid dataGrid(Kind kind, PageFilter ph, HttpServletRequest request) {
		SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute(GlobalConstant.SESSION_INFO);
		Grid grid = new Grid();
		grid.setRows(kindService.dataGrid(kind, ph, sessionInfo));
		grid.setTotal(kindService.count(kind, ph, sessionInfo));
		return grid;
	}

	@RequestMapping("/viewPage")
	public String viewPage(HttpServletRequest request, Long id) {
		Kind r = kindService.get(id);
		request.setAttribute("kind", r);
		return "/kind/kindView";
	}

	@RequestMapping("/addPage")
	public String addPage() {
		return "/kind/kindAdd";
	}

	@RequestMapping("/add")
	@ResponseBody
	public Json add(Kind kind, HttpServletRequest request) {
		SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute(GlobalConstant.SESSION_INFO);
		Json j = new Json();
		try {
			boolean flag = UploadUtils.chkImg(kind.getSourceFile(), request);
			if (!flag) {
				j.setMsg("上传图片的格式为：jpg , jpeg , png , gif ！");
				return j;
			} else {
				if (!kind.getSourceFile().isEmpty()) {
					UploadUtils.createMultipartHttpServletRequest2(request);
					String imgPath = UploadUtils.uploadImg(kind.getSourceFile(), request);
					kind.setImgPath(imgPath);
				}
			}
			kindService.add(sessionInfo, kind);
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
			kindService.delete(id, request);
			j.setMsg("删除成功！");
			j.setSuccess(true);
		} catch (Exception e) {
			j.setMsg(e.getMessage());
		}
		return j;
	}

	@RequestMapping("/get")
	@ResponseBody
	public Kind get(Long id) {
		return kindService.get(id);
	}

	@RequestMapping("/editPage")
	public String editPage(HttpServletRequest request, Long id) {
		Kind r = kindService.get(id);
		request.setAttribute("kind", r);
		return "/kind/kindEdit";
	}

	@RequestMapping("/edit")
	@ResponseBody
	public Json edit(Kind kind, HttpServletRequest request) {
		Json j = new Json();
		try {
			if(kind.getImgPath()!=null && !"".equals(kind.getImgPath())){
				UploadUtils.deleteBeforeImg(request, kind.getImgPath());
			}
			boolean flag = UploadUtils.chkImg(kind.getSourceFile(), request);
			if (!flag) {
				j.setMsg("上传图片的格式为：jpg , jpeg , png , gif ！");
				return j;
			} else {
				if (!kind.getSourceFile().isEmpty()) {
					UploadUtils.createMultipartHttpServletRequest2(request);
					String imgPath = UploadUtils.uploadImg(kind.getSourceFile(), request);
					kind.setImgPath(imgPath);
				}
				kindService.edit(kind);
				j.setSuccess(true);
				j.setMsg("编辑成功！");
			}
		} catch (Exception e) {
			j.setMsg(e.getMessage());
		}
		return j;
	}

	@RequestMapping("/queryById")
	@ResponseBody
	public List<Kind> queryById(HttpServletRequest request, Integer categoryId) {
		return kindService.queryById(categoryId);
	}
	
	@RequestMapping("/tree")
	@ResponseBody
	public List<Tree> tree() {
		return kindService.tree();
	}

	// @RequestMapping("/export")
	// @ResponseBody
	// public String exportExcel(Customer customer, PageFilter ph,
	// HttpServletRequest request,
	// HttpServletResponse response) throws IOException {
	// SessionInfo sessionInfo = (SessionInfo)
	// request.getSession().getAttribute(GlobalConstant.SESSION_INFO);
	// List<Customer> customerList = customerService.dataGrid(customer, ph,
	// sessionInfo);
	// String fileName = "客户信息导出";
	// LinkedList<Map<String, String>> list = createExcelRecord(customerList);
	// ByteArrayOutputStream os = new ByteArrayOutputStream();
	// ExcelExportUtil.generateExcel(list, fileName).write(os);
	// ExcelExportUtil.createStream(response, fileName, os);
	// return null;
	// }

	// // 导出设置值
	// private LinkedList<Map<String, String>> createExcelRecord(List<Customer>
	// customerList) {
	// LinkedList<Map<String, String>> listmap = new LinkedList<Map<String,
	// String>>();
	// Customer customer = null;
	// for (int j = 0; j < customerList.size(); j++) {
	// customer = customerList.get(j);
	// LinkedHashMap<String, String> mapValue = new LinkedHashMap<String,
	// String>();
	// mapValue.put("序号", customer.getId().toString());
	// mapValue.put("客户名称", customer.getCustName());
	// mapValue.put("性别", customer.getCustSex() == 0 ? "男" : "女");
	// mapValue.put("年龄", customer.getCustAge().toString());
	// mapValue.put("电话", customer.getCustPhone());
	// mapValue.put("身份证", customer.getIdCard());
	// mapValue.put("微信号", customer.getCustWebchat());
	// mapValue.put("QQ号 ", customer.getCustQq());
	// mapValue.put("地址 ", customer.getCustAddress());
	// mapValue.put("备注", customer.getRemark());
	// mapValue.put("创建时间 ", customer.getCreateDatetime().toString());
	// listmap.add(mapValue);
	// }
	// return listmap;
	// }
}
