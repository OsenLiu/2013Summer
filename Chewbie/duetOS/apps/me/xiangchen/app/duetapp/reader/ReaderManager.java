package me.xiangchen.app.duetapp.reader;

import me.xiangchen.app.duetapp.AppManager;
import me.xiangchen.app.duetos.LauncherManager;
import me.xiangchen.app.duetos.R;
import me.xiangchen.ui.xacSketchCanvas;

public class ReaderManager extends AppManager {

	public static void setTool(int tool, boolean feedback) {
		if (phone != null) {
			Reader reader = (Reader) phone;
			reader.setTool(tool, feedback);
		}
	}

	public static void undo() {
		if (phone != null) {
			Reader reader = (Reader) phone;
			reader.undo();
//			LauncherManager.showNotificationOnUnlockedPhone(R.drawable.undo);
		}
	}

	public static void redo() {
		if (phone != null) {
			Reader reader = (Reader) phone;
			reader.redo();
//			LauncherManager.showNotificationOnUnlockedPhone(R.drawable.redo);
		}
	}

	public static void showToolPallete() {
		if (watch != null) {
			ReaderExtenstion readerExtension = (ReaderExtenstion) watch;
			readerExtension.showToolPallete();
		}
	}

	public static void incrTextSize() {
		if (phone != null) {
			Reader reader = (Reader) phone;
			reader.incrTextSize();
		}
	}

	public static void decrTextSize() {
		if (phone != null) {
			Reader reader = (Reader) phone;
			reader.decrTextSize();
		}
	}

	public static void incrBrightness() {
		if (phone != null) {
			Reader reader = (Reader) phone;
			reader.incrBrightness();
		}
	}

	public static void decrBrightness() {
		if (phone != null) {
			Reader reader = (Reader) phone;
			reader.decrBrightness();
		}
	}
	
	public static void showTextOption(String text) {
		if(watch != null) {
			ReaderExtenstion readerExtension = (ReaderExtenstion) watch;
			readerExtension.showTextOption(text);
		}
	}
	
	public static void showTooltip(String text) {
		if(watch != null) {
			ReaderExtenstion readerExtension = (ReaderExtenstion) watch;
			readerExtension.showText(text);
		}
	}
	
	public static int getTool() {
		int tool = xacSketchCanvas.NONE;
		if (phone != null) {
			Reader reader = (Reader) phone;
			tool = reader.getTool();
		}
		return tool;
	}
}
