# frozen_string_literal: true

namespace :scholars_archive do
  desc 'Fix visibility'
  task fix_work_visibility: :environment do
    fix_work_visibility
  end
  task retrieve_model_name: :environment do
    retrieve_model_name
  end

  def retrieve_model_name
    datetime_today = DateTime.now.strftime('%m-%d-%Y-%H-%M-%p') # "10-27-2017-12-59-PM"
    logger = ActiveSupport::Logger.new("#{Rails.root}/log/get-model-name-#{datetime_today}.log")
    input_list = %w[5712m880q 5999n672q 5q47rs50r 6395wb890 9p290d94w fj236557c h702q7965 jd473182z jw827h15c s4655j71h sj139549f tq57nv23h vm40xw219]

    input_list.each do |id|
      w = ActiveFedora::Base.find(id)
      solr_index = w.to_solr
      work_model = solr_index['has_model_ssim'].first
      logger.info "#{w.id}: #{work_model}"
    rescue StandardError => e
      logger.info "\tfailed to retrieve model name for work #{id}: #{e.message} #{e.backtrace}"
    end
  end

  def fix_work_visibility
    datetime_today = DateTime.now.strftime('%m-%d-%Y-%H-%M-%p') # "10-27-2017-12-59-PM"
    logger = ActiveSupport::Logger.new("#{Rails.root}/log/fix-work-visibility-#{datetime_today}.log")
    to_be_fixed = %w[00000312d 00000352c 000004209 02870z72z 02870z74h 02870z79w 02871009k 05741w43z 0g354j530 0p0969375 0p096b10z 0r967697t 0r9678161 1544br050 1544br57r 1544bs87p 1831cp401 1c18dj079 1j92gb71s 1n79h7299 1n79h731b 1v53k1145 1z40kw38m 2227ms652 2227mt01q 2514np926 2514nq80m 2514nq81w 2801pj749 2801pj91z 2b88qf638 2b88qf70p 2b88qg98k 2b88qh593 2f75rb716 2j62s816k 2n49t430q 2n49t526b 2r36v118p 2r36v1210 2r36v194h 2z10ws58r 2z10wt80g 3197xq76d 3484zk178 3484zk34x 3484zk95n 3484zm44c 3484zn16d 37720g17n 37720h10x 37720h84q 3f462885j 3n204141r 3n2042231 3n2042249 3n204268c 3r074x66z 3t945t33m 3t945t46p 3t945v18q 3t945w196 41687k03g 41687m456 44558h780 4f16c559k 4j03d159m 4j03d1903 4j03d276g 4m90dz28v 4m90dz42p 4m90dz85g 4m90f0219 4t64gr415 4x51hm43r 5138jh421 5138jh838 5138jh89x 5138jj81x 5425kg137 5712m843k 5712m880q 5712m964j 5712mb54h 5999n672q 5999n6862 5h73pz81s 5h73q0085 5h73q068m 5h73q127k 5m60qw885 5q47rq977 5q47rs44m 5q47rs50r 5q47rt24b 5q47rt25m 5q47rt26w 5t34sn54w 6108vd76h 6108vf76q 6395w951v 6395wb05z 6395wb44n 6395wb84m 6395wb890 6682x8290 6h440w03d 6h440w067 6h440w44n 6h440w865 6m311r335 6t053k07h 6t053m632 6w924d90j 70795b12x 76537338b 76537353f 7d278x473 7h149r59q 7h149s77v 7m01br07t 7p88cj75t 7p88cj827 7p88ck42g 7p88cm09n 7s75dh42x 7w62fd671 8049g761h 8049g8396 8049g898c 8336h4108 8336h554j 8336h5563 8623j1008 8910jz74b 8k71nk02n 8k71nk92t 8k71nm36p 8p58ph37g 9019s508v 9019s535r 9306t193p 9306t274p 9306t282c 9306t3509 9593tx97t 9880vt131 9880vt95h 9880vv383 9c67wq04k 9c67wq20z 9c67wr01z 9k41zj33q 9k41zk193 9p290d94w 9s161900v 9s161980s 9w032515h 9w032632c 9w0327476 9z9032577 9z9034243 9z903426n 9z903427x b2773z38d b2774020b b5644v97t b5644w679 b8515q81z b8515q941 b8515r263 bc386n82z bn9999007 br86b650p br86b700p br86b737b bv73c2553 bv73c3249 bz60d099m c247dv51m c247dw27r c534fr84d c821gm967 c821gn068 cf95jd072 cf95jd76g cf95jf02w cj82kc07q cj82kc721 cn69m594z cn69m768r cv43nz99n d217qr942 d217qt32g d217qv13g d504rp11r d504rq020 d791sj95s db78tg25t db78th340 df65vc39d dj52w7253 dj52w816b dn39x435v dn39x474j dr26z156v dv13zx401 dz010t73z f4752k11h f7623f290 f7623g17d fb4949990 fb494c232 fb494c649 fb494d70n ff3658018 ff3658531 ff3658795 fj236418g fj236557c fn1071742 fq977z00s fq978011p ft848s76z ft848v36d fx719q32b fx719q401 fx719q85c g158bm093 g158bm182 g158bm61b g158bn07r g445cg66r g445ch44x gf06g5981 gf06g634p gq67js949 gq67jt41g gx41mn52p h128nh39g h415pd47d h415pd78d h702q7965 h702q853k h702q944t h702q969p h702q977c h989r667m hd76s362g hd76s3659 hm50tv96d hq37vq71v hq37vr05g hq37vr071 hq37vr49j hq37vr87z hx11xh84d hx11xj644 j098zf488 j3860945m j67316952 j96023631 jd472z42d jd472z77h jd473105v jd473182z jq085n040 jq085p887 js956j445 js956j45f js956k35d js956k89q jw827f09t jw827h15c k0698b11d k0698b571 k3569785f k3569800b k3569848h k930c095z k930c1424 kd17cw56m kh04ds03t kh04ds531 kk91fn87v kk91fp758 ks65hf941 ks65hh43z m039k708r m039k743b m613n024d m613n1507 m613n2805 m900nx64n m900nz02v mc87pt22m mg74qq12m mk61rk24f ms35td765 mw22v793n mw22v925x n009w391f n009w580b n296x248s n583xz32z nc580p315 ng451m360 nk322f993 nk322g00n nk322g204 nk322g70b nk322j508 ns0648215 ns064b24d nv935552c nv935718g nv935737p p2676x27f p2676z58n p2676z937 p26770556 p5547t64t p5547w583 pc289m36d pc289m532 pg15bg754 pk02cf74h pn89d952r pn89d9574 pn89db473 pn89db60n pr76f7569 pv63g2920 pv63g382z pz50gz05q pz50h116t q237hv09c q811km650 qb98mh867 qb98mj057 qb98mj898 qf85nf83v qf85ng54m qj72p937s qj72p9845 qn59q6204 qr46r3083 qv33s1922 qz20sv29z qz20sx682 r207tr333 r207tt726 r494vn984 r781wj61q r781wj74s rb68xf18z rb68xg096 rb68xg16m rb68xh16t rf55zb81z rf55zc29x rj4307535 rj4307977 rn301358k rr172261t rv042w453 rv042x637 rx913s78v s1784p34b s1784p91z s1784q30f s4655j71h s4655m64h s7526g485 sf268679h sf268915k sj139547w sj139549f sn00b118g sn00b195k st74ct776 st74ct88q st74ct890 sx61dr34v t148fn05z t435gh03f t722hd31v tb09j843z tb09j975f th83m188j th83m193d th83m346f tm70mx60x tm70mz32z tq57nt310 tq57nv09p tq57nv23h tt44pp74t tx31qp040 tx31qp104 v118rg88z v118rg97x v118rj830 v692t913j v692t914t v692t997k v979v597w vd66w463q vh53x0463 vm40xw219 vm40xw953 vq27zq81v vq27zq93n vq27zr898 vq27zt008 vx021h26d vx021h696 w0892f132 w0892g10f w3763947x w6634685k w6634688d w6634725b w66347969 w9505357n w95054630 wd375z50v wm117t333 wm117t34c wp988p24d wp988q044 ww72bg76n x059cb48t x059cb557 x346d6779 x346d768j x346d784x x633f4357 x920g018m x920g070v x920g1460 xd07gw197 xd07gx46b xk81jq579 xp68kj27p xs55mf375 xs55mg648 xw42nb08z xw42nb55b xw42nc28n z316q3701 z316q408r z603r157x zg64tq43c zg64tq512 zs25xc67r]

    counter = 0
    to_be_fixed.each do |id|
      logger.info "Fixing visibility for work #{id} so that it matches existing embargo visibility if any"
      begin
        w = ActiveFedora::Base.find(id)
        solr_index = w.to_solr
        workflow_state = solr_index['workflow_state_name_ssim']
        work_model = solr_index['has_model_ssim'].first

        if workflow_state.nil?
          # no workflow state found, so log and find out what to do for this case
          logger.info "\t[no workflow state set] visitility was not changed for work #{w.id} (#{work_model}), visibility_ssi: #{solr_index['visibility_ssi']}, workflow_state_name_ssim: \"#{workflow_state}\", embargo: {#{w.embargo.to_hash.to_s if w.embargo}}"
        elsif workflow_state && workflow_state.downcase.strip == 'deposited'
          # workflow is known to be deposited:
          if w.embargo && w.embargo_release_date && w.embargo_release_date > DateTime.now
            # (1st case) 'works' with active embargo and future release date (un-expired embargo):

            if w.visibility_during_embargo && w.visibility_during_embargo == 'authenticated' && w.visibility == 'restricted'
              # assign proper permissions: ['private', 'public', 'registered']
              w.read_groups = ['registered']
              set_grad_year_if_nil(w)
              if w.save
                logger.info "\tsuccessfully changed visibility from restricted to #{w.visibility} for work #{w.id} (#{work_model})"
                counter += 1
              else
                logger.info "\t[unable to save work] visitiliby was not changed for work #{w.id} (#{work_model}), visibility_ssi: #{solr_index['visibility_ssi']}, workflow_state_name_ssim: \"#{workflow_state}\", embargo: {#{w.embargo.to_hash.to_s if w.embargo}}"
              end
            else
              logger.info "\t[visibility_during_embargo not restricted or not set] visibility was not changed for work #{w.id} (#{work_model}), visibility_ssi: #{solr_index['visibility_ssi']}, workflow_state_name_ssim: \"#{workflow_state}\", embargo: {#{w.embargo.to_hash.to_s if w.embargo}}"
            end

            # fix visibility for child members if any
            fix_child_member_visibility_during_embargo(parent_work: w, logger: logger)
          elsif w.embargo && w.embargo_release_date && w.embargo_release_date < DateTime.now
            # (2nd case) 'works' with active embargo and past release date (expired embargo):
            if w.visibility_after_embargo && w.visibility_after_embargo == 'authenticated' && w.visibility == 'restricted'
              # assign proper permissions: ['private', 'public', 'registered']
              w.read_groups = ['registered']
              set_grad_year_if_nil(w)
              w.embargo.save(validate: false)
              if w.save(validate: false)
                logger.info "\tsuccessfully changed visibility from restricted to #{w.visibility} for work #{w.id} (#{work_model})"
                counter += 1
              else
                logger.info "\t[unable to save work] visibility was not changed for work #{w.id} (#{work_model}), visibility_ssi: #{solr_index['visibility_ssi']}, workflow_state_name_ssim: \"#{workflow_state}\", embargo: {#{w.embargo.to_hash.to_s if w.embargo}}"
              end
            else
              logger.info "\t[visibility_after_embargo not restricted or not set] visibility was not changed for work #{w.id} (#{work_model}), visibility_ssi: #{solr_index['visibility_ssi']}, workflow_state_name_ssim: \"#{workflow_state}\", embargo: {#{w.embargo.to_hash.to_s if w.embargo}}"
            end

            # fix visibility for child members if any
            fix_child_member_visibility_after_embargo(parent_work: w, logger: logger)
          else
            logger.info "\t[embargo and/or embargo_release_date not set] visibility was not changed for work #{w.id} (#{work_model}), visibility_ssi: #{solr_index['visibility_ssi']}, workflow_state_name_ssim: \"#{workflow_state}\", embargo: {#{w.embargo.to_hash.to_s if w.embargo}}"
          end
        else
          # workflow is known but not marked as 'deposited', log and find out what to do for this case
          logger.info "\t[workflow state set but not marked as 'Deposited'] visibility was not changed for work #{w.id} (#{work_model}), visibility_ssi: #{solr_index['visibility_ssi']}, workflow_state_name_ssim: \"#{workflow_state}\", embargo: {#{w.embargo.to_hash.to_s if w.embargo}}"
        end
      rescue StandardError => e
        logger.info "\tfailed to fix visibility for work #{id}: #{e.message}"
      end
    end
    logger.info "Done. Fixed a total of #{counter} works."
  end

  def set_grad_year_if_nil(w)
    if %w[undergraduate_thesis_or_project graduate_thesis_or_dissertation honors_college_thesis purchase_e_resource graduate_project].include?(w.model_name.singular)
      w.graduation_year = '' if w.graduation_year.nil?
    end
  end

  def fix_child_member_visibility_during_embargo(parent_work:, logger:)
    parent_work.ordered_members.to_a.each do |f|
      if f.embargo && f.visibility_during_embargo && f.visibility_during_embargo == 'authenticated' && f.visibility == 'restricted'
        logger.info "\tfixing visibility for child work #{f.id} - #{f.model_name.plural} (parent work #{parent_work.id}) so that it matches existing embargo visibility if any"
        child_solr_index = f.to_solr
        f.read_groups = ['registered']
        if f.save
          logger.info "\tsuccessfully changed visibility from restricted to #{f.visibility} for child work #{f.id} - #{f.model_name.plural} (parent work #{parent_work.id})"
        else
          logger.info "\t[unable to save child work] visibility was not changed for child work #{f.id} #{f.model_name.plural} (parent work #{parent_work.id}), visibility_ssi: #{child_solr_index['visibility_ssi']}, workflow_state_name_ssim: \"#{child_solr_index['workflow_state_name_ssim']}\", embargo: {#{f.embargo.to_hash.to_s if f.embargo}}"
        end
      else
        logger.info "\t[visibility_during_embargo not restricted or not set] visibility was not changed for child work #{f.id} #{f.model_name.plural} (parent work #{parent_work.id}), visibility_ssi: #{child_solr_index['visibility_ssi']}, workflow_state_name_ssim: \"#{child_solr_index['workflow_state_name_ssim']}\", embargo: {#{f.embargo.to_hash.to_s if f.embargo}}"
      end
    end
  end

  def fix_child_member_visibility_after_embargo(parent_work:, logger:)
    parent_work.ordered_members.to_a.each do |f|
      if f.embargo && f.visibility_after_embargo && f.visibility_after_embargo == 'authenticated' && f.visibility == 'restricted'
        logger.info "\tfixing visibility for child work #{f.id} (parent work #{parent_work.id}) so that it matches existing embargo visibility if any"
        child_solr_index = f.to_solr
        f.read_groups = ['registered']
        if f.save(validate: false)
          logger.info "\tsuccessfully changed visibility from restricted to #{f.visibility} for child work #{f.id} - #{f.model_name.plural} (parent work #{parent_work.id})"
        else
          logger.info "\t[unable to save child work] visibility was not changed for child work #{f.id} #{f.model_name.plural} (parent work #{parent_work.id}), visibility_ssi: #{child_solr_index['visibility_ssi']}, workflow_state_name_ssim: \"#{child_solr_index['workflow_state_name_ssim']}\", embargo: {#{f.embargo.to_hash.to_s if f.embargo}}"
        end
      else
        logger.info "\t[visibility_after_embargo not restricted or not set] visibility was not changed for child work #{f.id} #{f.model_name.plural} (parent work #{parent_work.id}), visibility_ssi: #{child_solr_index['visibility_ssi']}, workflow_state_name_ssim: \"#{child_solr_index['workflow_state_name_ssim']}\", embargo: {#{f.embargo.to_hash.to_s if f.embargo}}"
      end
    end
  end
end
