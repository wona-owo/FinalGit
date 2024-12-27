package kr.or.iei.member.model.service;

import java.util.ArrayList;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import kr.or.iei.member.model.dao.MemberDao;
import kr.or.iei.member.model.vo.HashTag;
import kr.or.iei.member.model.vo.Member;
import kr.or.iei.member.model.vo.Search;
import kr.or.iei.post.model.vo.Post;

@Service("service")
public class MemberService {
	
	@Autowired
	@Qualifier("dao")
	private MemberDao memberDao;
	
	public int join(Member member) {
		return memberDao.join(member);
	}
	
	public Member memberLogin(Member member) {	
		return memberDao.memberLogin(member);
	}

	public int idDuplChk(String userId) {
		return memberDao.idDuplChk(userId);
	}

	public int nickDuplChk(String userNickname) {
		return memberDao.nickDuplChk(userNickname);
	}

	public int phoneDuplChk(String userPhone) {
		return memberDao.phoneDuplChk(userPhone);
	}

	public int apiJoin(Member member) {
		return memberDao.apiJoin(member);
	}

	public ArrayList<Member> searchUser(String search) { //키워드 입력시 실시간으로 관련 유저 보여줌
		// TODO Auto-generated method stub
		return (ArrayList<Member>)memberDao.searchUser(search);
	}

	public ArrayList<HashTag> searchTag(String searchStr) { //키워드 입력시 실시간으로 관련 해시태그 보여줌
		// TODO Auto-generated method stub
		return (ArrayList<HashTag>)memberDao.searchTag(searchStr);
	}
	public ArrayList<HashTag> searchHashTagsKeyword(String search) { //키워드와 관련된 해시태그 목록 가져오는거
		// TODO Auto-generated method stub
		return (ArrayList<HashTag>)memberDao.searchHashTagsKeyword(search);
	}
	
	public ArrayList<Member> searchUsersKeyword(String search) { //키워드와 관련된 유저 목록 가져오는거
		return (ArrayList<Member>)memberDao.searchUsersKeyword(search);
	}
	
	public int checkKeyword(int userNo, String search) { //중복되는 값 체크
		HashMap<String, Object> check = new HashMap<>();
	    check.put("userNo", userNo);
	    check.put("keyword", search);
	    return memberDao.checkKeyword(check);
	}

	public int updateKeywordDate(int userNo, String searchType, String userId, String search) { // 날짜만 업데이트
		HashMap<String, Object> update = new HashMap<>();
		update.put("userNo", userNo);
		update.put("searchType", searchType);
		update.put("userId", userId);
		update.put("keyword", search);
		return memberDao.updateKeywordDate(update);

	}
	
	public int insertKeyword(int userNo, String searchType, String userId, String search) { // 새롭게 등록
		HashMap<String, Object> insert = new HashMap<>();
		insert.put("userNo", userNo);
		insert.put("searchType", searchType);
		insert.put("userId", userId);
		insert.put("keyword", search);
		return memberDao.insertKeyword(insert);
	}

	public int deleteKeyword(int userNo, String keyword) { // 중복되는 값 삭제
		HashMap<String, Object> delete = new HashMap<>();
		delete.put("userNo", userNo);
		delete.put("keyword", keyword);
		return memberDao.deleteResultKeyword(delete);

	}
	
	public ArrayList<HashTag> selectKeywordTag(String hashName) {
		return (ArrayList<HashTag>)memberDao.selectKeywordTag(hashName);
	}
	
	public Member selectKeywordUser(String userName) {
		// TODO Auto-generated method stub
		return memberDao.selectKeywordUser(userName);
	}
	
	public HashTag selectTagName(String hashName) {
		return memberDao.selectTagName(hashName);
	}
	
	public int updateSearchHistory(int userNo, String searchType, String search) {
		HashMap<String, Object> update = new HashMap<>();
		update.put("userNo", userNo);
		update.put("keyword", search);
		update.put("searchType", searchType);
		return memberDao.updateSearchHistory(update);
	}
	
	public ArrayList<Search> selectSearchHistoryList(int userNo) {
		// TODO Auto-generated method stub
		return (ArrayList<Search>)memberDao.selectSearchHistoryList(userNo);
	}
	public int deleteSearchHistory(int userNo, String search, String searchType) {
		HashMap<String, Object> delete = new HashMap<>();
		delete.put("userNo", userNo);
		delete.put("search", search);
		delete.put("searchType", searchType);
		return memberDao.deleteSearchHistory(delete);
	}
	
	public int deleteAllSearchHistory(int userNo) {
		// TODO Auto-generated method stub
		 return memberDao.deleteAllSearchHistory(userNo); // DAO 호출
	}

	public int userDelete(String userId) {
		return memberDao.userDelete(userId);
	}

	public int updateProfile(Member member) {
		return memberDao.updateProfile(member);
	}



	


}
