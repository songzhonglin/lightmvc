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

import light.mvc.dao.BaseDaoI;
import light.mvc.model.szl.Tcategory;
import light.mvc.model.szl.Tkind;
import light.mvc.pageModel.base.PageFilter;
import light.mvc.pageModel.base.SessionInfo;
import light.mvc.pageModel.base.Tree;
import light.mvc.pageModel.szl.Kind;
import light.mvc.service.szl.KindServiceI;

@Service
public class KindServiceImpl implements KindServiceI {
	@Autowired
	private BaseDaoI<Tkind> kindDao;

	@Autowired
	private BaseDaoI<Tcategory> categoryDao;

	@Override
	public List<Kind> dataGrid(Kind kind, PageFilter ph, SessionInfo sessionInfo) {
		List<Kind> list = new ArrayList<Kind>();
		Map<String, Object> params = new HashMap<String, Object>();
		String hql = " from Tkind t ";
		List<Tkind> l = kindDao.find(hql + whereHql(kind, params, sessionInfo) + orderHql(ph), params, ph.getPage(),
				ph.getRows());
		for (Tkind t : l) {
			Kind c = new Kind();
			BeanUtils.copyProperties(t, c);
			list.add(c);
		}
		return list;
	}

	@Override
	public Long count(Kind kind, PageFilter ph, SessionInfo sessionInfo) {
		Map<String, Object> params = new HashMap<String, Object>();
		String hql = " from Tkind t ";
		return kindDao.count("select count(*) " + hql + whereHql(kind, params, sessionInfo), params);
	}

	private String whereHql(Kind kind, Map<String, Object> params, SessionInfo sessionInfo) {
		String hql = "";
		if (kind != null) {
			hql += " where 1=1 ";

			if (kind.getKindName() != null) {
				hql += " and t.kindName like :kindName";
				params.put("kindName", "%%" + kind.getKindName() + "%%");
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

	@Override
	public void add(SessionInfo sessionInfo, Kind kind) {
		Tkind c = new Tkind();
		BeanUtils.copyProperties(kind, c);
		c.setCreater(sessionInfo.getName());
		c.setCreateTime(new Date());
		c.setCategoryId(kind.getCategoryId());
		c.setImgPath(kind.getImgPath());
		kindDao.save(c);
	}

	@Override
	public void delete(Long id, HttpServletRequest request) {
		Tkind t = kindDao.get(Tkind.class, id);
		kindDao.delete(t);
	}

	@Override
	public void edit(Kind kind) {
		Tkind t = kindDao.get(Tkind.class, kind.getId());
		t.setKindCode(kind.getKindCode());
		t.setKindName(kind.getKindName());
		t.setRemark(kind.getRemark());
		t.setImgPath(kind.getImgPath());
		t.setCategoryId(kind.getCategoryId());
		kindDao.update(t);
	}

	@Override
	public Kind get(Long id) {
		Tkind t = kindDao.get(Tkind.class, id);
		Tcategory tc = categoryDao.get(Tcategory.class, t.getCategoryId().longValue());
		Kind r = new Kind();
		BeanUtils.copyProperties(t, r);
		r.setCategoryName(tc.getCategoryName());
		return r;
	}

	@Override
	public List<Kind> queryById(Integer categoryId) {
		List<Kind> lr = new ArrayList<Kind>();
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("categoryId", categoryId);
		List<Tkind> l = kindDao.find("from Tkind t where t.categoryId =:categoryId", params);
		if ((l != null) && (l.size() > 0)) {
			for (Tkind t : l) {
				Kind r = new Kind();
				BeanUtils.copyProperties(t, r);
				lr.add(r);
			}
		}
		return lr;
	}

	@Override
	public List<Tree> tree() {
		List<Tkind> l = null;
		List<Tree> lt = new ArrayList<Tree>();
		l = kindDao.find("select distinct t from Tkind t order by t.id");
		if ((l != null) && (l.size() > 0)) {
			for (Tkind r : l) {
				Tree tree = new Tree();
				tree.setId(r.getId().toString());
				tree.setText(r.getKindName());
				lt.add(tree);
			}
		}
		return lt;
	}
}
