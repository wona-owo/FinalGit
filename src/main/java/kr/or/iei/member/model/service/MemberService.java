package kr.or.iei.member.model.service;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import kr.or.iei.member.model.dao.MemberDao;
import kr.or.iei.member.model.vo.HashTag;
import kr.or.iei.member.model.vo.Member;
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

	public ArrayList<Member> searchUser(String searchStr) {
		// TODO Auto-generated method stub
		return (ArrayList<Member>)memberDao.searchUser(searchStr);
	}

	public ArrayList<HashTag> searchTag(String searchStr) {
		// TODO Auto-generated method stub
		return (ArrayList<HashTag>)memberDao.searchTag(searchStr);
	}

}
