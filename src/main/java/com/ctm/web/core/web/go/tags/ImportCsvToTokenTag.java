package com.ctm.web.core.web.go.tags;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.PageContext;

import au.com.bytecode.opencsv.CSVParser;

import com.ctm.web.core.web.go.FileUtils;
import com.ctm.web.core.web.go.TokenReplaceUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

public class ImportCsvToTokenTag extends BaseTag {

	private static final Logger LOGGER = LoggerFactory.getLogger(ImportCsvToTokenTag.class.getName());

	/**
	 *
	 */
	private static final long serialVersionUID = 1L;

	private int startRow;
	private int endRow;
	private int startColumn;
	private int endColumn;
	private String templateFilePath;
	private String templateVar;
	private String var;

	private String csvFilePath;

	private boolean encodeHtml = false;
	private boolean hasDimensions = false;

	public void setCsvFilePath(String csvFilePath) {
		this.csvFilePath = csvFilePath;
	}

	public void setTemplateFilePath(String templateFilePath) {
		this.templateFilePath = templateFilePath;
	}

	public void setTemplateVar(String templateVar) {
		this.templateVar = templateVar;
	}

	public void setStartRow(int detailsStartRow) {
		this.startRow = detailsStartRow;
	}
	public void setEncodeHtml(boolean encodeHtml) {
		this.encodeHtml  = encodeHtml;
	}
	public void setHasDimensions(boolean hasDimensions) {
		this.hasDimensions  = hasDimensions;
	}
	/**
	 * column to start tokens from begins at 1
	 * @param startColumn
	 */
	public void setStartColumn(int startColumn) {
		this.startColumn = startColumn;
	}

	public void setEndColumn(int endColumn) {
		this.endColumn = endColumn;
	}

	public void setEndRow(int endRow) {
		this.endRow = endRow;
	}


	/*
	 * (non-Javadoc)
	 *
	 * @see javax.servlet.jsp.tagext.BodyTagSupport#doEndTag()
	 */
	@Override
	public int doEndTag() throws JspException {

		List<String> xmls = getTokenReplacedFormat();

		// If result var was passed - put the resulting xml in the pagecontext's
		// variable
		if (this.var != null) {
			this.pageContext
					.setAttribute(var, xmls, PageContext.PAGE_SCOPE);
			// Otherwise - just splat it to the page
		} else {
			try {
				for(String xml :xmls) pageContext.getOut().write(xml);
			} catch (IOException e) {
				LOGGER.error("Failed to write to page. {}",kv("xmls",xmls) , e);
			}
		}

		clear();
		return EVAL_PAGE;
	}
	private void clear() {
		this.endColumn = 0;
		this.startRow = 0;
		this.endRow = 0;
		this.startColumn = 0;
		this.endColumn = 0;
		this.templateFilePath = "";
		this.templateVar = "";
		this.var = "";
		this.csvFilePath = "";
		this.encodeHtml = false;
		this.hasDimensions = false;
	}

	public List<String> getTokenReplacedFormat() {
		List<String> xmls = new ArrayList<String>();
		try {
			if(templateVar == null || templateVar.isEmpty()) {
				if(templateFilePath == null || templateFilePath.isEmpty()) {
					throw new IllegalArgumentException("templateValue or templateFilePath must be set");
				}
				else {
				templateVar = FileUtils.readFile(templateFilePath);
			}
			}

			BufferedReader in;
			in = new BufferedReader(new FileReader(new File(FileUtils.localPath(csvFilePath))));
			CSVParser parser = new CSVParser(',', '"');
			int lineNo = 0;
			while (lineNo <= startRow) {
				in.readLine();
				lineNo++;
			}

			Pattern pattern = TokenReplaceUtils.createPattern(startColumn, endColumn);

			String line;
			boolean endOfRows = false;
			while ((line = in.readLine()) != null && !endOfRows ) {
				String[] values = parseLine(line, in, parser);
				if(values != null) {
					if(endColumn == 0 || endColumn > values.length) {
						endColumn = values.length;
						pattern = TokenReplaceUtils.createPattern(startColumn, endColumn);
					}
					xmls.add(TokenReplaceUtils.getXML(values,
						templateVar, pattern, startColumn, endColumn, encodeHtml, hasDimensions, lineNo));
					if(endRow != -1 &&  lineNo == endRow) {
					endOfRows = true;
					}
				}
				lineNo++;
			}
			in.close();
		} catch (IOException e) {
			LOGGER.error("Failed to getTokenReplacedFormat", e);
		}

		return xmls;
	}

	/**
	 * parses line and returns array of string bases off  CSVParser
	 * grabs additional lines if there if there are unwanted wanted carriage returns
	 * @param line
	 * @param in
	 * @param parser
	 * @return
	 */
	private String[] parseLine(String line, BufferedReader in, CSVParser parser) {
		String[] values = null;
		try {
			values = parser.parseLine(line.replaceAll("[\\r\\n]", ""));
		} catch (IOException e) {
			// this is a hack because Excel add doesn't remove carriage returns when exporting to csv
			if(e.getMessage().contains("Un-terminated")) {
				String nextLine;
				try {
					nextLine = in.readLine();
					if(nextLine != null) {
						parseLine(line + "\n" + nextLine, in, parser);
					}
				} catch (IOException e1) {
					LOGGER.error("Failed to parse line.", e1);
				}
			} else {
				LOGGER.error("Failed to parse line.", e);
			}
		}
		return values;
	}

	/**
	 * Inits the.
	 */
	public void init() {
		this.startColumn = 1;
		this.startRow = 1;
		this.endRow = -1;
		this.csvFilePath = null;
		this.var = null;
		this.templateFilePath = null;
		this.templateVar = null;
	}

	public void setVar(String var) {
		this.var = var;
	}

	/**
	 * Sets the data var.
	 *
	 * @param dataVar
	 *            the new data var
	 * @throws Exception
	 *             the exception
	 */
	public void setFilePath(String filePath) throws Exception {
		this.csvFilePath = filePath;
	}

	/**
	 * Sets the value.
	 *
	 * @param var
	 *            the new value
	 */

	public void setXmlTemplateFilePath(String xmlTemplateFilePath) {
		this.templateFilePath = xmlTemplateFilePath;
	}
}
