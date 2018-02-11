package light.mvc.service.szl;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import light.mvc.pageModel.base.PageFilter;
import light.mvc.pageModel.base.SessionInfo;
import light.mvc.pageModel.base.Tree;
import light.mvc.pageModel.szl.Kind;

public interface KindServiceI {
	public List<Kind> dataGrid(Kind kind, PageFilter ph, SessionInfo sessionInfo);

	public Long count(Kind Kind, PageFilter ph,SessionInfo sessionInfo);

	public void add(SessionInfo sessionInfo, Kind kind);

	public void delete(Long id, HttpServletRequest request);

	public void edit(Kind kind);

	public Kind get(Long id);
	
	public List<Kind> queryById(Integer categoryId);

	public List<Tree> tree();
}
