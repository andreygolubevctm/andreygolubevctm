package nl.captcha.backgrounds;

import java.awt.AlphaComposite;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.Random;

import javax.imageio.ImageIO;

public final class RandomImagePosBackgroundProducer implements BackgroundProducer {

    private String _image;

    public RandomImagePosBackgroundProducer() {
        _image=null;
    }

    public RandomImagePosBackgroundProducer(String imagePath) {
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
        		BufferedImage.TYPE_INT_ARGB);
                
        // load the image
        try {
	        BufferedImage bg = ImageIO.read(new File(_image));
			Graphics2D graphics = img.createGraphics();

	        // xcoord
	        int minX = width-bg.getWidth();
	        int maxX = 0;
	        int minY = height-bg.getHeight();
	        int maxY = 0;
	        
	        Random rand = new Random();
	        
	        int x = rand.nextInt(maxX - minX + 1) + minX;
	        int y = rand.nextInt(maxY - minY + 1) + minY;

			
	        //graphics.setComposite(AlphaComposite.Src);
	        graphics.drawImage(bg, x, y, null);
	        graphics.dispose();
			
		} catch (IOException e) {
			e.printStackTrace();
		}

        return img;
    }
}
