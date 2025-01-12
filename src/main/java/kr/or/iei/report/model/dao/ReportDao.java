package kr.or.iei.report.model.dao;

import java.util.ArrayList;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import kr.or.iei.report.model.vo.Report;

@Repository("reportDao")
public class ReportDao {

	@Autowired
	@Qualifier("sqlSessionTemplate")
	private SqlSessionTemplate sqlSession;

	public int insertReport(Report report) {
		return sqlSession.insert("report.insertReport", report);
	}

	public List<Report> reportList() {
		return sqlSession.selectList("report.reportList");
	}
	
}
