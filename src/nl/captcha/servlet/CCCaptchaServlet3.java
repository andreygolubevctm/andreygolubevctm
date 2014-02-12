package nl.captcha.servlet;

import static nl.captcha.Captcha.NAME;

import java.awt.Color;
import java.awt.Font;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import nl.captcha.Captcha;
import nl.captcha.backgrounds.RandomImagePosBackgroundProducer;
import nl.captcha.gimpy.DropShadowGimpyRenderer;
import nl.captcha.gimpy.RippleGimpyRenderer;
import nl.captcha.text.producer.DefaultTextProducer;
import nl.captcha.text.renderer.DefaultWordRenderer;


/**
 * Generates, displays, and stores in session a 200x50 CAPTCHA image with sheared
 * black text, a solid dark grey background, and a slightly curved line over the
 * text.
 *
 * @author <a href="mailto:james.childers@gmail.com">James Childers</a>
 */
public class CCCaptchaServlet3 extends HttpServlet {

	private static final long serialVersionUID = 1L;

	private static int _width = 150;
	private static int _height = 50;
	private static String _bgPath = "/WEB-INF/captcha/captcha_bg2.jpg";

	private static final List<Color> COLORS = new ArrayList<Color>(2);
	private static final List<Font> FONTS = new ArrayList<Font>(3);

	static {

		COLORS.add(new Color(29, 47, 143));
		COLORS.add(new Color(233, 198, 44));
		COLORS.add(new Color(237, 237, 237));
		FONTS.add(new Font("Geneva", Font.ITALIC, 40));
		FONTS.add(new Font("Courier", Font.BOLD, 40));
		FONTS.add(new Font("Arial", Font.BOLD, 40));
	}

	@Override
	public void init(ServletConfig config) throws ServletException {
		super.init(config);
		if (getInitParameter("captcha-height") != null) {
			_height = Integer.valueOf(getInitParameter("captcha-height"));
		}

		if (getInitParameter("captcha-width") != null) {
			_width = Integer.valueOf(getInitParameter("captcha-width"));
		}

		if (getInitParameter("bg-path") != null) {
			_bgPath = String.valueOf(getInitParameter("bg-path"));
		}
		_bgPath = config.getServletContext().getRealPath(_bgPath);
	}

	@Override
	public void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {

		char[] chars = new char[] {'0', '1', '2', '3', '4', '5', '6', '7', '8','9'};

		DefaultTextProducer textProducer = new DefaultTextProducer(6, chars);

		DefaultWordRenderer wordRenderer = new DefaultWordRenderer(COLORS, FONTS);
		Captcha captcha = new Captcha.Builder(_width, _height)
				.addText(textProducer, wordRenderer)
				.addBackground(new RandomImagePosBackgroundProducer(_bgPath))
				.gimp(new RippleGimpyRenderer())
				.gimp(new DropShadowGimpyRenderer())
				.build();

		CaptchaServletUtil.writeImage(resp, captcha.getImage());
		HttpSession s = req.getSession();
		if (s != null){
			req.getSession().setAttribute(NAME, captcha);
		}
	}
}
