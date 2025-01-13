package kr.or.iei.report.model.dao;

import java.util.HashMap;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import kr.or.iei.member.model.vo.Member;
import kr.or.iei.report.model.vo.BanList;
import kr.or.iei.report.model.vo.MemberInfo;
import kr.or.iei.report.model.vo.Report;

@Repository("reportDao")
public class ReportDao {

	@Autowired
	@Qualifier("sqlSessionTemplate")
	private SqlSessionTemplate sqlSession;
	
	public Report searchReport(Report report) {
		return sqlSession.selectOne("report.searchReport", report);
	}

	public int searchTargetUser(Report report) {
		return sqlSession.selectOne("report.searchTargetUser", report);
	}
	
	public int insertReport(Report report) {
		return sqlSession.insert("report.insertReport", report);
	}

	public int updCntReport(Report searchReport) {
		return sqlSession.update("report.updCntReport", searchReport);
	}

	public List<Report> selectReportList(HashMap<String, Integer> map) {
		return sqlSession.selectList("report.selectReportList", map);
	}
	
	public List<BanList> selectBanList(HashMap<String, Integer> map) {
		return sqlSession.selectList("report.selectBanList", map);
	}
	
	public List<MemberInfo> selectUserList(HashMap<String, Integer> map) {
		return sqlSession.selectList("report.selectUserList", map);
	}

	public int selectAdminCount(String contentType) {
		return sqlSession.selectOne("report.selectAdminCount", contentType);
	}

	public Report selectReport(Report report) {
		return sqlSession.selectOne("report.selectReport", report);
	}
	
	public int updYnReport(Report selectReport) {
		return sqlSession.update("report.updYnReport", selectReport);
	}

	public int insertBanList(BanList banList) {
		return sqlSession.insert("report.insertBanList", banList);
	}

	public void unfreezeBan() {
		sqlSession.update("report.unfreezeBan");
	}
	
	public int selectAcctLevel(Member member) {
		return sqlSession.selectOne("report.selectAcctLevel", member);
	}

	public int updAcctLevel(Member member) {
		return sqlSession.update("report.updAcctLevel", member);
	}

	public int deleteReport(Report selectReport) {
		return sqlSession.delete("report.deleteReport", selectReport);
	}

	
}
