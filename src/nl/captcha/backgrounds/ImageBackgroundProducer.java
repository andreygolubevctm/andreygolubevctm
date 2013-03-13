package nl.captcha.backgrounds;

import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.Random;

import javax.imageio.ImageIO;

public final class ImageBackgroundProducer implements BackgroundProducer {

    private String _image;

    public ImageBackgroundProducer() {
        _image=null;
    }

    public ImageBackgroundProducer(String imagePath) {
    	_image = imagePath;
    }

    @Override
    public BufferedImage addBackground(BufferedImage bi) {
        int width = bi.getWidth();
        int height = bi.getHeight();
        return this.getBackground(width, height);
    }

    @Override
    public BufferedImage getBackground(int width, int height) {
        BufferedImage img = new BufferedImage(width, height,
        		BufferedImage.TRANSLUCENT);
        
        
        // load the image
        try {
			BufferedImage bg = ImageIO.read(new File(_image));
	        Graphics2D graphics = img.createGraphics();
	        
	        // xcoord
	        graphics.drawImage(bg, 0, 0, null);
	        graphics.dispose();
			
		} catch (IOException e) {
			e.printStackTrace();
		}

        return img;
    }
}
