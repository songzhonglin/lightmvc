package light.mvc.framework.resolver;

import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.i18n.AcceptHeaderLocaleResolver;

public class MyAcceptHeaderLocaleResolver extends AcceptHeaderLocaleResolver {
	private Locale myLocal;

	@Override
	public Locale resolveLocale(HttpServletRequest request) {
		return myLocal != null ? myLocal : request.getLocale();
	}

	@Override
	public void setLocale(HttpServletRequest request, HttpServletResponse response, Locale locale) {
		this.myLocal = locale;
	}

	public Locale getLocale() {
		return myLocal;
	}
}
