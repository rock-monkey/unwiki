require 'erb'
require 'yaml'

class Page
  include ERB::Util

  WIKIGAME_SHORTCODES = %w{invhasall invhasone invhasnone invpickup invdrop settoken gettoken test}
  OTHER_UNSUPPORTED_SHORTCODES = %w{nocomments}
  URL_REMAPS = {
    'http://www.scatmania.org/wp-content/paul_zippy.jpg'                                    => '/images/paul_zippy.jpg',
    'http://www.cleanstick.org/jon/junk/game/3waysplit.gif'                                 => '/images/wikimaze/3waysplit.gif',
    'http://www.cleanstick.org/jon/junk/game/blank.gif'                                     => '/images/wikimaze/blank.gif',
    'http://www.cleanstick.org/jon/junk/game/enemy.gif'                                     => '/images/wikimaze/enemy.gif',
    'http://www.cleanstick.org/jon/junk/game/forwardeft.gif'                                => '/images/wikimaze/forwardeft.gif',
    'http://www.cleanstick.org/jon/junk/game/forwardleft.gif'                               => '/images/wikimaze/forwardleft.gif',
    'http://www.cleanstick.org/jon/junk/game/forwardright.gif'                              => '/images/wikimaze/forwardright.gif',
    'http://www.cleanstick.org/jon/junk/game/goal.gif'                                      => '/images/wikimaze/goal.gif',
    'http://www.cleanstick.org/jon/junk/game/left.gif'                                      => '/images/wikimaze/left.gif',
    'http://www.cleanstick.org/jon/junk/game/lesbians.gif'                                  => '/images/wikimaze/lesbians.gif',
    'http://www.cleanstick.org/jon/junk/game/right.gif'                                     => '/images/wikimaze/right.gif',
    'http://www.cleanstick.org/jon/junk/game/straighton.gif'                                => '/images/wikimaze/straighton.gif',
    'http://www.cleanstick.org/jon/junk/game/tjunction.gif'                                 => '/images/wikimaze/tjunction.gif',
    'http://www.cleanstick.org/jon/junk/game/tubgirl.gif'                                   => '/images/wikimaze/tubgirl.gif',
    'http://www.tromanight.co.uk/images/avatars/gallery/tromaNight/avatar_andyrainbow.jpg'  => '/images/tn/avatar_andyrainbow.jpg',
    'http://www.tromanight.co.uk/images/avatars/gallery/tromaNight/adam.jpg'                => '/images/tn/adam.jpg',
    'http://www.tromanight.co.uk/images/avatars/gallery/tromaNight/alec.jpg'                => '/images/tn/alec.jpg',
    'http://www.tromanight.co.uk/images/avatars/gallery/tromaNight/andyk.jpg'               => '/images/tn/andyk.jpg',
    'http://www.tromanight.co.uk/images/avatars/gallery/tromaNight/avatar_andy.jpg'         => '/images/tn/avatar_andy.jpg',
    'http://www.tromanight.co.uk/images/avatars/gallery/tromaNight/avatar_hayley.jpg'       => '/images/tn/avatar_hayley.jpg',
    'http://www.tromanight.co.uk/images/avatars/gallery/tromaNight/avatar_jta.jpg'          => '/images/tn/avatar_jta.jpg',
    'http://www.tromanight.co.uk/images/avatars/gallery/tromaNight/bryn.jpg'                => '/images/tn/bryn.jpg',
    'http://www.tromanight.co.uk/images/avatars/gallery/tromaNight/claire.jpg'              => '/images/tn/claire.jpg',
    'http://www.tromanight.co.uk/images/avatars/gallery/tromaNight/dan.jpg'                 => '/images/tn/dan.jpg',
    'http://www.tromanight.co.uk/images/avatars/gallery/tromaNight/doreen.jpg'              => '/images/tn/doreen.jpg',
    'http://www.tromanight.co.uk/images/avatars/gallery/tromaNight/fiona.jpg'               => '/images/tn/fiona.jpg',
    'http://www.tromanight.co.uk/images/avatars/gallery/tromaNight/kit.jpg'                 => '/images/tn/kit.jpg',
    'http://www.tromanight.co.uk/images/avatars/gallery/tromaNight/liz.jpg'                 => '/images/tn/liz.jpg',
    'http://www.tromanight.co.uk/images/avatars/gallery/tromaNight/mark.jpg'                => '/images/tn/mark.jpg',
    'http://www.tromanight.co.uk/images/avatars/gallery/tromaNight/matt.jpg'                => '/images/tn/matt.jpg',
    'http://www.tromanight.co.uk/images/avatars/gallery/tromaNight/paul.jpg'                => '/images/tn/paul.jpg',
    'http://www.tromanight.co.uk/images/avatars/gallery/tromaNight/puddles.jpg'             => '/images/tn/puddles.jpg',
    'http://www.tromanight.co.uk/images/avatars/gallery/tromaNight/ruth.jpg'                => '/images/tn/ruth.jpg',
    'http://www.tromanight.co.uk/images/avatars/gallery/tromaNight/sian.jpg'                => '/images/tn/sian.jpg',
    'http://www.tromanight.co.uk/images/avatars/gallery/tromaNight/steve.jpg'               => '/images/tn/steve.jpg',
    'http://www.tromanight.co.uk/images/avatars/gallery/tromaNight/suz.jpg'                 => '/images/tn/suz.jpg',
    'http://www.tromanight.co.uk/images/avatars/gallery/tromaNight/will_keenan.jpg'         => '/images/tn/will_keenan.jpg'
  }
  # friendly tags that can always be displayed as two towrd
  FRIENDLY_TAGS = %w{AberSpar AberTechnium AberystwythPier AberystwythTown AbominableSnowman AbusiveRelationship AdvancedChemistry AffectionateInsult AidsFace
                     AihaHigurashi AlecRichardson AlexMatthews AllegedlyLives AnIllness AnalSex AndyKeohane AndyRegan AndysRecords AngrySalad AnimalKingdom
                     AnnabellaKrol AnonaMouse AnyKey AphexTwin ApoptygmaBerzerk AssassinationAttempt
                     AwfulFilms AwkwardMatt BaaLamb BabylonZoo BackStabbers BadJoke BadPages BananaPhone BarbWire BarbedWire BarraBrith BasiliskLizard
                     BaudelaireSiblings BeYourself BeautifulFreak BeckyHuntley BeigeBook BelleandSebastian BestPage BiSexual BigCloud BillDrummond BillGates
                     BillHicks BiologyStudents BirminghamEdgbaston BirminghamEgg BitchFruit BlackHole BlackSmoke BlueBook BoatRace BonfireNight BorisJohnson
                     BrandonFlowers BranwensAssistant BranwensRestaurant BreakingHorribly BrendonBurns BritishTea BritneySpears BrowserWindow BrynSalisbury
                     BubblegumPop BumFluff BumGravy BuyThings CableGuy CaiStrachen CallResponse CambrianPlace CarlsbergExport CatPower CategoryAuthors
                     CategoryBands CategoryBeers CategoryBiscuits CategoryBooks CategoryCategory CategoryCompanies CategoryComputers CategoryCreatures
                     CategoryDessert CategoryDirectors CategoryDrink CategoryEateries CategoryEditors CategoryElectronics CategoryEmotions
                     CategoryEntertainment CategoryEvents CategoryFilm CategoryFilms CategoryFish CategoryFood CategoryFruit CategoryGames
                     CategoryLyrics CategoryMusic CategoryNovels CategoryPeople CategoryPlaces CategoryPlanes CategoryQuotes CategoryRandom
                     CategoryRecursion CategoryRelationships CategoryReligion CategoryReligions CategorySex CategorySexualities CategorySocieties
                     CategorySongs CategorySweets CategoryTelevision CategoryTheatre CategoryThings CategoryTransport CategoryWiki ChannelFour ChatRoom
                     CheapWhores CheekyTykes ChezGeek ChezGoth ChezGreek ChezGrunt ChoirBoys CircleMaster ClagNuts ClaireMelton CockatriceCreature
                     CocteauTwins CoffeeMachine ColdLager CollosalCave ComedyNight ComedyWorks CommonSense ComputerScience ComputerScientist ComputerScientists
                     ContentiousFilms CoopersArms CouncilTax CourierMagazine CraigDavid CrapEnglish CryptoFascist CryptoPope CurryFire DanHuntley DanceMusic
                     DansCodebox DansSandbox DavidBowie DavidByrne DavidFirth DavidLynch DavidMysterious DavidPajo DaviesBryan DeadEnd DevendraBanhart
                     DevilsDictionary DickButler DiplomacyGame DoctorZarkov DoggyStyle DonnieDarko DrWho DramaStudents DrunkenIdiocy EarthMaterials EarthlyPlane
                     EastEnd EconomicDevelopment ElectroshockBlues EmacsEditor EmmaKeohane EmotionEric EmotionalOutbursts EnergyResources EnglandExpects
                     EnglishLiterature EnglishStudent EnriqueIglesias EuroDance EuropeanLanguages EuropeanParliament EuropeanUnion EvilLaugh EvilLaughs
                     ExeterGirl ExeterMan FacialHair FairUse FallOver FastFood FayeBromilow FemaleVagina FictionalCharacters FilmCritic FionaLane FionaMason
                     FleebleWidget FordGalaxie FormattingRules FortyFive FreeCondoms FreeWill FreeWilly FriedrichNietzsche FromMongo FrustratedTypes FullStop
                     FuriousLettuce GameOver GarethBowker GarethHopkins GeekNight GeneralElection GeographyStudents GeographyTower GestureRecognition
                     GlossyMagazine GnomishMines GoOutside GodKnows GoldFinger GoodFilms GossipMongering GreatHall GreenBook GreenTea GuineaPigs
                     HackerGame HalCruttenden HarryPotter HarukiMurakami HarvardUniversity HashBrownies HashBrowns HavingSex HayFever HayleyDrew HeadachesGirl
                     HeartAttacks HelpfulPorters HeteroSexual HighScore HighScores HipHop HobGoblin HollywoodPizza HomePage HugeRock IgorStravinsky IlluminatiGame
                     ImaginaryBand IncomeTax IndependentMusic InfernalPhone InlandRevenue InteractiveFiction InternalPhone InternationalPolitics
                     InternetExplorer IsobelCampbell JackDee JamieLidell JayenAitch JazzCigarettes JeffMinter JesusChrist JimCarrey JimMorrison JimmyCarter
                     JimmyCauty JoannaNewsom JohnParish JonAtkinson JonnyHowell JonsCar JonsTheory KeohaneClan KevinShields KitLane KnitClub KomodoDragons
                     KtErrington LagerBoy LandLine LanguagesStudent LawnmowerMan LearnDirect LeathermanMultitools LegacyProgram LembitOpik
                     LemonParty LemonySnicket LibDem LiberalDemocrat LiberalDemocrats LinkPage LittleBritain LittleMistake LizHague
                     LowfromDuluth LycanthropicPerson LyndaRollason LynxBrowser MacOs MacSomethings MagLite MagicalPlanes MagicalTrevor
                     MaldwynCountdown MaliciousSlurs ManlyMan ManlyMen MargaretThatcher MarkRatcliffe MartinSheen MathematicsStudents MattPayne
                     MattReynolds MayfairGames McCulloch MeanRumours MediocreFilms MeteorImpact MicrosoftAccess MicrosoftCorporation MicrosoftExcel
                     MicrosoftFrontpage MicrosoftOffice MicrosoftWindows MicrosoftWord MicrosoftWorks MidWales MilfordCubicle MilitantVegetarians
                     MiltonSirotta MontyPython MooCow MoreLesbians MortalEnemy MouldMonster MountainDew MoveAlong
                     MozillaFirefox MrPlagioclase MrRockmonkey MullhollandDrive MunchkinGame MusicalChairs MutuallyExclusive
                     NegativeCampaigning NewLabour NewStuff NickDrake NickServ NoMoney NoisyNookie NormalLife NormalPeople NoshDa NoveltyRecords
                     OggVorbis OperatingEnvironment OperatingSystem OralSex OrangeBook OrphanedPages OtherPeople OtherRuth OurFilms OurUniverse
                     OutdoorPursuits OwnedPages PacifistVegetarians PageIndex PalaceBrothers PalaceMusic PalaceSongs PamelaAnderson
                     PartsUnknown PassingNotes PasswordForgotten PaulMann PenKnife PenbrynHalls PenglaisCampus PerlLanguage PeterHain
                     PettyPeople PhallicSculptures PhilipPullman PhysicsBuilding PierVideo PinkNoise PixiesReunion PlaidCymru
                     PositiveCampaigning PresidentBartlet PrimeExample ProgrammingLanguage
                     PropellorheadReason ProperDegrees PsychoEx QuantumPhysicists QuimNinja RachelKeohane RainbowBooks RancidCack
                     RazorWire ReadingUniversity RealAle RealLife RealWorld RecentChanges RecentNews RecentlyCommented RedBook
                     ReferencialIntegrity ReferentialIntegrity RegularExpression ReligiousArguments ReligiousTypes RentBoys RestlessBooks
                     RestlessFilms RestlessMusic RetardBoy RichardStallman RiskNight RiverYstwyth RiversCuomo RobManuel RobertaWilliams
                     RobinVarley RockCandy RockHammer RocksLtd RumbletumsCafe RunAway RuthVarley SacredVows SaladFingers
                     SantaClaus SeanandJo SearchEngine SecondarySchool SecretLaundry SedimentaryRocks SelectiveMemory SensibleIndividuals SexualPositions
                     SharpenedRadish ShingaiManyiwa ShotDown SianThomas SideBurns SignificantOther SimonBurns SinglePeople SmallCushions SoftSynth
                     SoftwareEngineering SomeMoney SomePeople SomeThing SomethingSons SoundMaster SpiritedAway SpitefulInsults SpontaneousCombustion
                     StellaArtois StephenHawking SteveBallmer StrokeyAdam StuartEkers StudentsUnion StupidQuestions SugarBowl SundeepBraich SuzChilestone
                     SwearWords SwissRoll TalkingHeads TapeTrading TastyLager TeaBag TeachingMonkey TechnicalSupport TechnicallyIllegal TemporaryWorker
                     TextFile TextSearch ThankYou ThatOne TheAssembly TheDevil TheDoors TheFilm TheFlat TheFuckers TheGame TheGods TheGuide TheHouse TheJams
                     TheJoint TheKillers TheLine TheMask TheMind TheOrb ThePentagon ThePlace ThePoint TheSofa TheStylophonics TheTimelords TheUniverse
                     TheoreticalPhysicists ThisSpace TicTacs TidalWave TimePorn TorrentialDownpour TotalBollocks TromaNight TromaStudios TrustedComputing
                     TuitionFees TwinPeaks UltimateAnswer UltimateQuestion UndergroundBunker UnitedKingdom UnitedNations UniversityCrest UnrealAle
                     UrbaneConversation UsageStatistics ViEditor VirtualReality VoteHere WantedPages WarpRecords WebBrowser WellingtonBoots
                     WelshLanguage WestEnd WestWales WesternWorld WhiteBook WikiCategory WikiGames WikiMaze WikiName WikiPage WikiRace WikiSpam
                     WillOldham WindowsLonghorn WingedAnts WinstonChurchill WonderBoy WordMonkey WordPad WrongThing WuffleNuts WychwoodBrewery YaleLock
                     YellowBook YesMinister YouLiar YouSchmuck}

  attr_reader :id, :tag, :time, :body, :owner, :user, :read_acl, :write_acl, :comment_acl, :formatted

  def self.all
    return @@all_pages if (@@all_pages ||= nil)
    @@all_pages = YAML::load(File::read('db/pages.yml')).map{|row| Page.new(row)}
    @@all_pages.each(&:generate_formatted)
    @@all_pages
  end

  def self.find_by_tag(tag)
    all.select{|page| page.tag == tag}[0]
  end

  def self.missing_pages
    @@missing_pages ||= []
  end

  def self.find_all_containing_word(word)
    all.select{|page| page.body =~ /(\W|^)#{word}(\W|$)/}
  end

  def self.user_names
    @@user_names ||= (all.map(&:user) + all.map(&:owner)).uniq
  end

  def self.friendly_tag_for(tag)
    is_friendly = false
    is_friendly = true if Page.user_names.include?(tag)
    is_friendly = true if tag =~ /^([A-Z][a-z]+){3,}$/
    is_friendly = true if FRIENDLY_TAGS.include?(tag)
    is_friendly ? (tag.gsub(/([A-Z])/, ' \1').strip) : tag
  end

  def initialize(row)
    @id, @tag, @time, @body, @owner, @user, @read_acl, @write_acl, @comment_acl = row['id'], row['tag'], row['time'], row['body'], row['owner'], row['user'], row['read_acl'], row['write_acl'], row['comment_acl']
  end

  def friendly_tag
    Page.friendly_tag_for(tag)
  end

  def comments
    @comments ||= Comment.find_all_by_page_tag(@tag)
  end

  def generate_formatted
    @formatted = h(@body)
    # Fix known broken images
    URL_REMAPS.each do |from, to|
      @formatted.gsub!(from, to)
    end
    # Pre-process by fixing windows line endings
    @formatted.gsub!(/\r\n/, "\n")
    # Downcasify all shortcodes to protect them from being turned into links (DANGER: breaks some images)
    @formatted.gsub!(/\{\{[^\} ]*/){|shortcode| shortcode.downcase}
    # Add warning if using unsupported shortcodes
    @formatted = %{<div class="wikigame-shortcodes">This page used WikiGameToolkit shortcodes, which are not supported in this version of the site.</div>#{@formatted}} if WIKIGAME_SHORTCODES.any?{|code| @formatted =~ /\{\{#{code}/}
    # Strip duplicate page titles
    @formatted.gsub!(/^[^\n]*=+ *#{@tag} *=+[^\n]*/, '')
    # Strip leading/trailing newlines
    @formatted.gsub!(/^\n+/, '')
    @formatted.gsub!(/\n+$/, '')
    # Process wiki code
    @formatted.gsub!(/\n+----+\n+/, '<hr />')
    @formatted.gsub!(/\n*&gt;&gt;(.+?)&gt;&gt;\n*/m, '<aside>\1</aside>')
    @formatted.gsub!(/''(.+?)''/, '<strong class="highlight">\1</strong>')
    @formatted.gsub!(/\*\*(.+?)\*\*/, '<strong>\1</strong>')
    @formatted.gsub!(/([^:])\/\/(.*[^:])\/\//, '\1<em>\2</em>')
    @formatted.gsub!(/##(.+?)##/, '<pre>\1</pre>')
    @formatted.gsub!(/%%(.+?)%%/, '<pre>\1</pre>')
    @formatted.gsub!(/\+\+(.+?)\+\+/, '<strike>\1</strike>')
    @formatted.gsub!(/__(.+?)__/, '<u>\1</u>')
    @formatted.gsub!(/@@(.+?)@@/, '<center>\1</center>')
    @formatted.gsub!(/\n*#%(.+?)#%\n*/, '<div class="button">\1</div>')
    @formatted.gsub!(/\n*={6} *(.+?) *={6}\n*/, '<h1>\1</h1>')
    @formatted.gsub!(/\n*={5} *(.+?) *={5}\n*/, '<h2>\1</h2>')
    @formatted.gsub!(/\n*={4} *(.+?) *={4}\n*/, '<h3>\1</h3>')
    @formatted.gsub!(/\n*={3} *(.+?) *={3}\n*/, '<h4>\1</h4>')
    @formatted.gsub!(/\n*={2} *(.+?) *={2}\n*/, '<h5>\1</h5>')
    @formatted.gsub!(/\n*(~- *([^\n]*))(\n *~-([^\n]*))*\n*/) do |list|
      items = list.gsub('~-', '<li>').gsub("\n", '</li>')
      "<ul>#{items}</ul>"
    end
    @formatted.gsub!(/\n/, "<br />\n")
    @formatted.gsub!(/(<br \/>\n){2,}</, "<br />\n<")
    @formatted.gsub!(/\{\{(.+?)( +(.+?)=&quot;(.+?)&quot;)*\}\}/) do |shortcode|
      code, params = shortcode[2...-2].split(/\s/, 2)
      params = (params || '').scan(/ *(.+?)=&quot;(.+?)&quot;/) || []
      params = Hash.new.tap{ |h| params.each{ |k,v| h[k] = v } }
      if code == 'image'
        alt = (params['alt'] || '').gsub(/([A-Z])/, ' \1').strip # break up ALL WikiWords in alt text to prevent links being 'made' there
        image = %{<img src="#{params['url']}" alt="#{alt}" class="#{params['class']}" />}
        image = %{<a href="/#{params['link']}">#{image}</a>} if(params['link'])
        image
      elsif code == 'category'
        page_tags = Page.find_all_containing_word(@tag).map(&:tag)
        lis = page_tags.map{|t| %{<li>#{t}</li>} }.join('')
        %{<ul>#{lis}</ul>}
      elsif code == 'wantedpages'
        File.exists?('tmp/wantedpages.html') ? File.read('tmp/wantedpages.html') : ''
      elsif WIKIGAME_SHORTCODES.include?(code) || OTHER_UNSUPPORTED_SHORTCODES.include?(code)
        # drop
      else
        "<div>UNKNOWN SHORTCODE: #{code} (#{h(params.inspect)})</div>"
      end
    end
    # Wiki Links (WikiWords and [[]]-syntax)
    @formatted.gsub!(/\[\[.+?\]\]|(?<![\/])([A-Z][a-z0-9]+)([A-Z][a-z0-9]*)+/) do |link|
      link = link.gsub(/[\[\[\]\]]/, '').split(' ', 2)
      link[1] ||= link[0]
      # friendlify link text if possible
      link[1] = Page.friendly_tag_for(link[1])
      classes = []
      if link[0] =~ /^https?:/
        if link[0] =~ /http:\/\/www\.rockmonkey\.org\.uk\//
          # selfref eg category page
          classes << 'internal'
          classes << 'ext-category'
          url = "/#{link[0].gsub('http://www.rockmonkey.org.uk/', '')}"
        else
          # regular external link
          url = link[0]
          classes << 'external'
        end
      else
        url = "/#{link[0]}"
        classes << 'internal'
        unless Page.find_by_tag(link[0])
          # broken link; attempt obvious fixes
          if Page.find_by_tag(link[0].capitalize)
            # fixed it!
            link[0] = link[0].capitalize
            classes << 'auto-fixed'
          else
            # nope; still broken - let's try something else
            if alt_page = Page.all.select{|page| page.tag.downcase == link[0].downcase}[0]
              # phew! that worked
              link[0] = alt_page.tag
              classes << 'auto-fixed'
            else
              # still nothing? damn: let's give up!
              (@@missing_pages ||= []) << link[0]
              classes << 'broken'
            end
          end
        end
      end
      %{<a href="#{url}" class="#{classes.join(' ')}">#{link[1]}</a>}
    end
    # Add comments
    if comments.length > 0
      comments_html = comments.map{|comment| %{<blockquote class="comment"><div class="body">#{comment.comment}</div><cite><a href="/#{comment.user}">#{comment.user}</a></cite></blockquote>} }
      @formatted = %{#{@formatted}<div class="comments">#{comments_html.join("\n")}</div>}
    end
    @formatted
  end
end
