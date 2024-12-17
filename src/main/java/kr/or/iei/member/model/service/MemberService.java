package kr.or.iei.member.model.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import kr.or.iei.member.model.dao.MemberDao;

@Service("service")
public class MemberService {
	
	@Autowired
	@Qualifier("dao")
	private MemberDao memberDao;

}
