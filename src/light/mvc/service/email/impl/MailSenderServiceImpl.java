package light.mvc.service.email.impl;

import java.util.Map;

import javax.mail.MessagingException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import light.mvc.service.email.MailSenderService;
import light.mvc.service.email.MailSenderServiceI;

@Service
public class MailSenderServiceImpl implements MailSenderServiceI {

	@Autowired
	private MailSenderService mailSender;

	@Override
	public void sendMailWithVelocityTemplate(String to, String mailSubject, String templateLocation,
			Map<String, Object> velocityContext) {
		sendEmail(to, mailSubject, templateLocation, velocityContext);
	}

	/**
	 * 发送邮件通知
	 * 
	 * @param to
	 * @param mailSubject
	 * @param templateLocation
	 * @param velocityContext
	 */
	private void sendEmail(String to, String mailSubject, String templateLocation,
			Map<String, Object> velocityContext) {
		mailSender.setTo(to);
		mailSender.setSubject(mailSubject);
		mailSender.setTemplateName(templateLocation);// 设置的邮件模板
		try {
			mailSender.sendHtmlByTemplate(velocityContext);
		} catch (MessagingException e) {
			e.printStackTrace();
			System.out.println("邮件发送失败！");
		}
		System.out.println("邮件发送成功！");
	}

}
