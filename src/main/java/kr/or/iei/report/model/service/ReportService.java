package kr.or.iei.report.model.service;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import kr.or.iei.report.model.dao.ReportDao;
import kr.or.iei.report.model.vo.Report;

@Service("reportService")
public class ReportService {
	
	@Autowired
	@Qualifier("reportDao")
	private ReportDao dao;

	public int insertReport(Report report) {
		return dao.insertReport(report);
	}

	public ArrayList<Report> reportList() {
		return (ArrayList<Report>) dao.reportList();
	}
	
}
