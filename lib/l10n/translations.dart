// lib/l10n/translations.dart
// ─────────────────────────────────────────────────────────────────────────────
// UNEC Assistant — Translation Dictionary
// Languages: English (en) · Azerbaijani (az) · Russian (ru)
// ─────────────────────────────────────────────────────────────────────────────

enum AppLocale { en, az, ru }

class AppStrings {
  final AppLocale locale;
  const AppStrings(this.locale);

  String _t(String en, String az, String ru) {
    switch (locale) {
      case AppLocale.en:
        return en;
      case AppLocale.az:
        return az;
      case AppLocale.ru:
        return ru;
    }
  }

  // ── Navigation ────────────────────────────────────────────────────────────
  String get navHome => _t('Home', 'Ana Səhifə', 'Главная');
  String get navFunctions => _t('Functions', 'Funksiyalar', 'Функции');
  String get navFeed => _t('News Feed', 'Xəbər Lenti', 'Новостная Лента');
  String get navNotifications =>
      _t('Notifications', 'Bildirişlər', 'Уведомления');
  String get navProfile => _t('Profile', 'Profil', 'Профиль');

  // ── Home Section Labels ───────────────────────────────────────────────────
  String get sectionClassAttendance =>
      _t('Class & Attendance', 'Dərs & Davamiyyət', 'Занятие и Посещаемость');
  String get sectionAcademic => _t('Academic', 'Akademik', 'Академическое');
  String get sectionNewsFeed =>
      _t('News Feed', 'Xəbər Lenti', 'Новостная Лента');

  // ── Teacher Ranks & Depts ─────────────────────────────────────────────────
  String get rankAssociateProfessor =>
      _t('Associate Professor', 'Dosent', 'Доцент');
  String get rankHeadOfDept =>
      _t('Head of Dept.', 'Kafedra müdiri', 'Зав. кафедрой');
  String get deptCS => _t('CS Dept.', 'Kompüter elmləri kaf.', 'каф. КН');
  String get deptPhysics => _t('Physics Dept.', 'Fizika kaf.', 'каф. физики');
  String get sectionPersonal => _t('Personal', 'Şəxsi', 'Личное');
  String get sectionAboutUs => _t('About Us', 'Haqqımızda', 'О нас');
  String get sectionContactUs => _t('Contact Us', 'Bizimlə Əlaqə', 'Связаться');
  String get sectionAboutApp =>
      _t('About App', 'Proqram Haqqında', 'О Приложении');

  // ── Profile Screen ────────────────────────────────────────────────────────
  String get profileSectionAcademic =>
      _t('Academic', 'Akademik', 'Академическое');
  String get profileSectionApplication =>
      _t('Application', 'Tətbiq', 'Приложение');
  String get profileSectionFeedback =>
      _t('Feedback & Support', 'Rəy & Dəstək', 'Отзывы и Поддержка');

  // ── Settings Card 1 ───────────────────────────────────────────────────────
  String get settingsAcademicProfile =>
      _t('Academic Profile', 'Akademik Profil', 'Академический Профиль');
  String get settingsAcademicProfileSub => _t(
    'Your full transcript',
    'Tam akademik qeydiyyatınız',
    'Ваша полная успеваемость',
  );
  String get settingsUnecCabinet =>
      _t('Unec Cabinet', 'UNEC Kabineti', 'Кабинет UNEC');
  String get settingsUnecCabinetSub => _t(
    'Direct link to your cabinet',
    'Kabinetinizə birbaşa keçid',
    'Прямая ссылка на кабинет',
  );
  String get settingsChangePassword =>
      _t('Change Password', 'Şifrəni Dəyişdir', 'Изменить Пароль');
  String get settingsChangePasswordSub =>
      _t('Resets your password', 'Şifrəni sıfırlayır', 'Сбросить пароль');

  // ── Settings Card 2 ───────────────────────────────────────────────────────
  String get settingsAppTheme =>
      _t('App Theme', 'Proqram Mövzusu', 'Тема Приложения');
  String get settingsNotifications =>
      _t('Notifications', 'Bildirişlər', 'Уведомления');
  String get settingsAboutApp =>
      _t('About App', 'Proqram Haqqında', 'О Приложении');
  String get settingsAboutAppVersion => _t(
    'v 1.1.0 IT team inc.',
    'v 1.1.0 IT team inc.',
    'v 1.1.0 IT team inc.',
  );
  String get settingsLanguage => _t('Language', 'Dil', 'Язык');

  // ── Theme Labels ──────────────────────────────────────────────────────────
  String get themeSystem => _t('System', 'Sistem', 'Система');
  String get themeLight => _t('Light', 'İşıqlı', 'Светлая');
  String get themeDark => _t('Dark', 'Qaranlıq', 'Тёмная');

  // ── Language Names (always in their own script) ───────────────────────────
  String get langEnglish => 'English';
  String get langAzerbaijani => 'Azərbaycan dili';
  String get langRussian => 'Русский язык';

  // ── App Drawer ────────────────────────────────────────────────────────────
  String get drawerTitle =>
      _t('App Directory', 'Proqram Kataloqu', 'Каталог Приложения');
  String get drawerSubtitle => _t(
    'Quick access to all features',
    'Bütün xüsusiyyətlərə sürətli çıxış',
    'Быстрый доступ ко всем функциям',
  );
  String get drawerSectionNewsSocial =>
      _t('NEWS & SOCIAL', 'XƏBƏRLƏR & SOSIAL', 'НОВОСТИ И СОЦСЕТИ');
  String get drawerSectionAcademic =>
      _t('ACADEMIC', 'AKADEMİK', 'АКАДЕМИЧЕСКОЕ');
  String get drawerSectionMaterials =>
      _t('MATERIALS & NOTES', 'MATERİALLAR & QEYDLƏR', 'МАТЕРИАЛЫ И ЗАМЕТКИ');
  String get drawerSectionAccount => _t('ACCOUNT', 'HESAB', 'АККАУНТ');
  String get drawerNewsFeed =>
      _t('News Feed', 'Xəbər Lenti', 'Новостная Лента');
  String get drawerCreatePost =>
      _t('Create Post', 'Paylaşım Yarat', 'Создать Запись');
  String get drawerManageChannels =>
      _t('Manage Channels', 'Kanalları İdarə Et', 'Управление Каналами');
  String get drawerAttendance => _t('Attendance', 'Davamiyyət', 'Посещаемость');
  String get drawerWeeklySchedule =>
      _t('Weekly Schedule', 'Həftəlik Cədvəl', 'Расписание');
  String get drawerCurrentClass =>
      _t('Current Class', 'Cari Dərs', 'Текущее Занятие');
  String get drawerAllGrades =>
      _t('All Grades', 'Bütün Qiymətlər', 'Все Оценки');
  String get drawerGradeCalculator =>
      _t('Grade Calculator', 'Qiymət Kalkulyatoru', 'Калькулятор Оценок');
  String get drawerSubjects => _t('Subjects', 'Fənnlər', 'Предметы');
  String get drawerTeachingMaterials =>
      _t('Teaching Materials', 'Tədris Materialları', 'Учебные Материалы');
  String get drawerSmartSync =>
      _t('Smart Sync', 'Ağıllı Sinxronizasiya', 'Умная Синхронизация');
  String get drawerNotes => _t('Notes', 'Qeydlər', 'Заметки');
  String get drawerMyProfile =>
      _t('My Profile', 'Mənim Profilim', 'Мой Профиль');
  String get drawerStudentIdCard =>
      _t('Student ID Card', 'Tələbə Vəsiqəsi', 'Студенческий Билет');
  String get drawerAcademicProfile =>
      _t('Academic Profile', 'Akademik Profil', 'Академический Профиль');
  String get drawerSecurityPassword => _t(
    'Security & Password',
    'Təhlükəsizlik & Şifrə',
    'Безопасность и Пароль',
  );
  String get drawerShareProfile =>
      _t('Share Profile', 'Profili Paylaş', 'Поделиться Профилем');
  String get drawerAboutApp =>
      _t('About App', 'Proqram Haqqında', 'О Приложении');

  // ── Current Class Card & Button ───────────────────────────────────────────
  String get currentClassLabel =>
      _t('CURRENT CLASS', 'CARİ DƏRS', 'ТЕКУЩЕЕ ЗАНЯТИЕ');
  String get currentClassUpNext => _t('UP NEXT', 'SONRAKI', 'СЛЕДУЮЩЕЕ');
  String get currentClassNoActive => _t(
    'No class is currently active',
    'Hal-hazırda aktiv dərs yoxdur',
    'Активных занятий нет',
  );
  String get currentClassLaterToday =>
      _t('Later today', 'Bu gün sonra', 'Позже сегодня');
  String get currentClassTomorrow => _t('Tomorrow', 'Sabah', 'Завтра');
  String get currentClassUpcoming =>
      _t('Upcoming', 'Gözlənilir', 'Предстоящее');
  String get currentClassRoom => _t('Room', 'Otaq', 'Аудитория');
  String get currentClassSubject => _t('Subject', 'Fənn', 'Предмет');
  String get currentClassType => _t('Type', 'Növ', 'Тип');
  String get currentClassTeacher => _t('Teacher', 'Müəllim', 'Преподаватель');
  String get currentClassProgressLine =>
      _t('Progress Line', 'Tərəqqi Xətti', 'Линия Прогресса');
  String get currentClassStarts => _t('starts', 'başlanır', 'начало');
  String get currentClassEnds => _t('ends', 'bitir', 'конец');
  String get currentClassTimeLeft =>
      _t('Time left', 'Qalan vaxt', 'Оставшееся время');
  String get currentClassCompleted =>
      _t('Completed', 'Tamamlandı', 'Выполнено');
  String currentClassFloor(int n, String suffix) =>
      _t('on the $n$suffix floor', '$n-ci mərtəbədə', 'на $n-м этаже');
  String get currentClassBtnTitle =>
      _t('Current class', 'Cari dərs', 'Текущее занятие');
  String get currentClassBtnSub => _t(
    "Ongoing class, it's materials and info",
    'Dərsin materialları və məlumatları',
    'Материалы и информация о занятии',
  );

  // ── Schedule Card & Button ────────────────────────────────────────────────
  String get scheduleUpcomingExam =>
      _t('Upcoming Exam', 'Gözlənilən İmtahan', 'Предстоящий Экзамен');
  String get schedulePersonalPlan =>
      _t('Personal Plan', 'Şəxsi Plan', 'Личный Plan');
  String get scheduleActive => _t('ACTIVE', 'AKTİV', 'АКТИВНО');
  String get scheduleToday => _t('Today', 'Bu gün', 'Сегодня');
  String get scheduleTomorrow => _t('Tomorrow', 'Sabah', 'Завтра');
  String get scheduleTime => _t('Time', 'Vaxt', 'Время');
  String get scheduleBtnTitle => _t('Schedule', 'Cədvəl', 'Расписание');
  String get scheduleBtnSub =>
      _t('For the semester', 'Semestr üçün', 'На семестр');

  // ── Attendance Card ───────────────────────────────────────────────────────
  String get attendanceBtnTitle =>
      _t('Attendance', 'Davamiyyət', 'Посещаемость');
  String get attendanceBtnSub =>
      _t('Absence count', 'Qayıb sayı', 'Количество пропусков');
  String get attendanceUsed => _t('used', 'istifadə edilib', 'использовано');
  String attendanceLimit(int n) => _t('Limit : $n', 'Limit : $n', 'Лимит : $n');
  String attendanceLeftPill(int n) => _t('$n Left', '$n Qaldı', '$n Осталось');
  String get attendanceNoLeft =>
      _t('no absence left', 'qayıb hüququ qalmayıb', 'пропусков не осталось');
  String attendanceAbsencesLeft(int n) =>
      _t('$n absences left', '$n qayıb qaldı', '$n пропусков осталось');

  // ── Grade Card ────────────────────────────────────────────────────────────
  String get gradeFinalNotScheduled => _t(
    'Final not scheduled yet',
    'Final hələ təyin olunmayıb',
    'Финал еще не назначен',
  );
  String get gradeMidtermNotScheduled => _t(
    'Midterm not scheduled yet',
    'Aralıq imtahanı hələ təyin olunmayıb',
    'Промежуточный экзамен еще не назначен',
  );
  String get gradeSeminarLabel =>
      _t('SEMINAR GRADE', 'SEMİNAR QİYMƏTİ', 'ОЦЕНКА ЗА СЕМИНАР');
  String get gradeMidtermLabel =>
      _t('MIDTERM GRADE', 'YARIYIL QİYMƏTİ', 'ОЦЕНКА ЗА РУБЕЖНЫЙ');
  String get gradeFinalLabel =>
      _t('FINAL EXAM GRADE', 'YEKUN İMTAHAN QİYMƏTİ', 'ОЦЕНКА ЗА ФИНАЛЬНЫЙ');
  String get gradeMidtermExam =>
      _t('Midterm Exam', 'Yarıyıl İmtahanı', 'Рубежный Экзамен');
  String get gradeFinalExam =>
      _t('Final Exam', 'Yekun İmtahan', 'Финальный Экзамен');
  String get gradeDateReceived =>
      _t('Date received', 'Alınma tarixi', 'Дата получения');

  // ── Notes ───────────────────────────────────────────────────────────────
  String get noteRecentLabel =>
      _t('RECENT NOTE', 'SON QEYD', 'ПОСЛЕДНЯЯ ЗАМЕТКА');
  String get noteUntitled => _t('Untitled', 'Başlıqsız', 'Без названия');
  String get noteNoContent => _t(
    'No additional content',
    'Əlavə məzmun yoxdur',
    'Дополнительного содержимого нет',
  );
  String get notesTitle => _t('Notes', 'Qeydlər', 'Заметки');
  String get notesSearchHint =>
      _t('Search notes...', 'Qeydləri axtar...', 'Поиск заметок...');
  String get notesSectionPersonal =>
      _t('Personal Folders', 'Şəxsi Qovluqlar', 'Личные Папки');
  String get notesSectionClass =>
      _t('Class Folders', 'Dərs Qovluqları', 'Папки Предметов');
  String get noteEditorTitleHint =>
      _t('Note Title', 'Qeyd Başlığı', 'Заголовок заметки');
  String get noteEditorDone => _t('Done', 'Hazırdır', 'Готово');
  String get noteEditorStartTyping =>
      _t('Start typing...', 'Yazmağa başlayın...', 'Начните печатать...');
  String get noteEditorPaper => _t('Paper', 'Kağız', 'Бумага');
  String get notesDeleteTitle =>
      _t('Delete Note?', 'Qeydi Sil?', 'Удалить заметку?');
  String notesDeleteDesc(String title) => _t(
    'Are you sure you want to delete "$title"? This action cannot be undone.',
    '"$title" qeydini silmək istədiyinizə əminsiniz? Bu əməliyyat geri alına bilməz.',
    'Вы уверены, что хотите удалить "$title"? Это действие нельзя отменить.',
  );
  String get notesDeleteCancel => _t('Cancel', 'Ləğv Et', 'Отмена');
  String get notesDeleteConfirm => _t('Delete', 'Sil', 'Удалить');
  String get notesSearchFolderHint =>
      _t('Search in folder...', 'Qovluqda axtar...', 'Поиск в папке...');
  String get notesEmptyFolder => _t(
    'No notes in this folder',
    'Bu qovluqda qeyd yoxdur',
    'В этой папке нет заметок',
  );
  String get notesEmptySearch => _t(
    'No notes matching your search',
    'Axtarışınıza uyğun qeyd tapılmadı',
    'По вашему запросу заметок не найдено',
  );
  String get noteFolderOneNote => _t('1 note', '1 qeyd', '1 заметка');
  String noteFolderNotes(int count) =>
      _t('$count notes', '$count qeyd', '$count заметок');
  // ── News Feed ─────────────────────────────────────────────────────────────
  String get feedTitle => _t('News Feed', 'Xəbər Lenti', 'Новостная Лента');
  String get feedSearchHint =>
      _t('Search posts...', 'Paylaşımları axtar...', 'Поиск записей...');
  String get feedNoPosts =>
      _t('No posts found', 'Paylaşım tapılmadı', 'Записей не найдено');
  String get feedFilterDiscover => _t('Discover', 'Kəşfet', 'Открытие');
  String get feedFilterSubscribed =>
      _t('Subscribed', 'Abunə Olunmuş', 'Подписки');
  String get feedFilterOfficial => _t('Official', 'Rəsmi', 'Официальное');
  String get feedFilterClubs => _t('Clubs', 'Klublar', 'Клубы');
  String get feedFilterDevTeam =>
      _t('Dev Team', 'Dev Komandası', 'Команда Dev');
  String get feedReadMore => _t('Read more', 'Daha çox oxu', 'Читать далее');
  String get feedShowLess => _t('Show less', 'Daha azını göstər', 'Свернуть');
  String get feedJustNow => _t('Just now', 'İndicə', 'Только что');
  String get feedLinkCopied => _t(
    'Link copied to clipboard',
    'Keçid mübadilə buferinə kopyalandı',
    'Ссылка скопирована',
  );
  String get feedCategoryOfficial => _t('Official', 'Rəsmi', 'Официальное');
  String get feedCategoryClubs => _t('Clubs', 'Klublar', 'Клубы');
  String get feedCategoryDevTeam =>
      _t('Dev Team', 'Dev Komandası', 'Команда Dev');
  String feedTimeAgoDay(int n) => _t('${n}d ago', '${n}g əvvəl', '$nд назад');
  String feedTimeAgoHour(int n) =>
      _t('${n}h ago', '${n}s əvvəl', '$nч назад');
  String feedTimeAgoMin(int n) => _t('${n}m ago', '${n}d əvvəl', '$nм назад');

  // ── Manage Channels ───────────────────────────────────────────────────────
  String get channelsTitle => _t(
    'Manage Subscribed Channels',
    'Abunə Kanalları İdarə Et',
    'Управление Подписками',
  );
  String get channelsNoSubs =>
      _t('No subscriptions yet', 'Hələ abunə yoxdur', 'Подписок пока нет');
  String get channelsSubscribeHint => _t(
    'Subscribe to channels from the Feed\nto see them here.',
    'Onları burada görmək üçün Lentdən kanallara abunə olun.',
    'Подпишитесь на каналы в Ленте,\nчтобы они появились здесь.',
  );
  String get channelsUnsubscribe =>
      _t('Unsubscribe', 'Abunəlikdən Çıx', 'Отписаться');

  // ── Post Detail ───────────────────────────────────────────────────────────
  String get postNotFound =>
      _t('Post not found', 'Yazı tapılmadı', 'Запись не найдена');
  String get postCommentMostRecent =>
      _t('Most recent', 'Ən yeni', 'Самые новые');
  String get postCommentMostLiked =>
      _t('Most liked', 'Ən çox bəyənilmiş', 'Самые популярные');

  // ── Notifications ─────────────────────────────────────────────────────────
  String get notifTitle => _t('Notifications', 'Bildirişlər', 'Уведомления');
  String get notifMarkAllRead => _t(
    'Mark all as read',
    'Hamısını oxunmuş kimi işarələ',
    'Отметить всё как прочитанное',
  );
  String get notifNoneYet => _t(
    'No notifications yet',
    'Hələ bildiriş yoxdur',
    'Уведомлений пока нет',
  );
  String get notifDisabledTitle => _t(
    'Notifications are turned off',
    'Bildirişlər söndürülüb',
    'Уведомления отключены',
  );
  String get notifDisabledSub => _t(
    'You can enable them in Settings to stay updated.',
    'Yenilənmiş qalmaq üçün onları Parametrlərdə aktivləşdirə bilərsiniz.',
    'Включите их в Настройках, чтобы получать обновления.',
  );
  String get notifGroupToday => _t('Today', 'Bugün', 'Сегодня');
  String get notifGroupYesterday => _t('Yesterday', 'Dünən', 'Вчера');

  // ── Notification Content ──────────────────────────────────────────────────
  String get notifAcademicTitle => _t('SPRING semester midterm schedule', 'YAZ semestri ara imtahan cədvəli', 'Расписание промежуточных экзаменов ВЕСЕННЕГО семестра');
  String get notifAcademicBody => _t(
    'The midterm exam schedule for the SPRING semester of the 2025/2026 academic year has been announced.',
    '2025/2026-ci tədris ilinin YAZ semestri üçün ara imtahan cədvəli açıqlanmışdır.',
    'Объявлено расписание промежуточных экзаменов на ВЕСЕННИЙ семестр 2025/2026 учебного года.',
  );
  String get notifFeedTitle => _t('New Post in Rectorate Channel', 'Rektorat Kanalında Yeni Paylaşım', 'Новый пост в канале Ректората');
  String get notifFeedBody => _t('Professor Mammadov shared a new announcement.', 'Professor Məmmədov yeni bir elan paylaşdı.', 'Профессор Мамедов опубликовал новое объявление.');
  String get notifAttendanceTitle => _t('Attendance Warning', 'Davamiyyət Xəbərdarlığı', 'Предупреждение о посещаемости');
  String notifAttendanceBody(int n, String subject) => _t(
    'You have missed $n classes of "$subject".',
    'Siz "$subject" fənnindən $n dərs qayıb limitini keçmisiniz.',
    'Вы пропустили $n занятий по предмету "$subject".',
  );
  String get notifUpdateTitle => _t('App Update Available', 'Tətbiq Yeniləməsi Mövcuddur', 'Доступно обновление приложения');
  String notifUpdateBody(String v) => _t(
    'Version $v is now available with new features.',
    'Yeni funksiyalarla $v versiyası artıq mövcuddur.',
    'Версия $v теперь доступна с новыми функциями.',
  );


  // ── Academic Profile ──────────────────────────────────────────────────────
  String get academicProfileTitle =>
      _t('Academic profile', 'Akademik profil', 'Академический Профиль');
  String get academicInfoTitle => _t(
    'Academic information',
    'Akademik məlumatlar',
    'Академическая Информация',
  );
  String get academicStandingTitle =>
      _t('Academic standing', 'Akademik vəziyyət', 'Академический Статус');
  String get academicClubMemberships =>
      _t('Club memberships', 'Klub üzvlükləri', 'Членство в Клубах');
  String get academicFaculty => _t('Faculty', 'Fakültə', 'Факультет');
  String get academicMajor => _t('Major', 'İxtisas', 'Специализация');
  String get academicYear => _t('Year', 'Kurs', 'Курс');
  String get academicEnrolled =>
      _t('Enrolled', 'Qeydiyyat tarixi', 'Дата Зачисления');
  String get academicGpa =>
      _t('Cumulative GPA', 'Ümumi Ortalama', 'Средний Балл GPA');
  String get academicActive => _t('Active', 'Aktiv', 'Активен');
  String get academicShareBtn => _t(
    'Share student profile',
    'Tələbə profilini paylaş',
    'Поделиться Профилем Студента',
  );
  String get academicShareBtnSub => _t(
    'Generate a clean shareable text',
    'Paylaşıla bilən səliqəli mətn yarat',
    'Создать чистый текст для публикации',
  );

  // ── About App ─────────────────────────────────────────────────────────────
  String get aboutAppTitle =>
      _t('About App', 'Proqram Haqqında', 'О Приложении');
  String get aboutAppRowPlatforms =>
      _t('Platforms', 'Platformalar', 'Платформы');
  String get aboutAppRowVersion => _t('Version', 'Versiya', 'Версия');
  String get aboutAppRowMinSdk =>
      _t('Minimum SDK', 'Minimum SDK', 'Минимальный SDK');
  String get aboutAppRowLicense => _t('License', 'Lisenziya', 'Лицензия');
  String get aboutAppRowFramework => _t('Framework', 'Framework', 'Framework');
  String get aboutAppRowLanguage =>
      _t('Language', 'Proqramlaşdırma dili', 'Язык Программирования');

  // ── About Us Card ─────────────────────────────────────────────────────────
  String get aboutUsHelloHeading => _t('Hello World,', 'Salam,', 'Привет,');
  String get aboutUsHelloBodyPre =>
      _t('I am a first-year ', 'Mən UNEC-in birinci kurs ', 'Я первокурсник ');
  String get aboutUsHelloBodyBold =>
      _t('IT student at UNEC', 'IT tələbəsiyəm', 'факультета ИТ в UNEC');
  String get aboutUsHelloBodyPost => _t(
    ' with a passion for building software that solves real-world challenges.',
    ', real problemləri həll edən proqramlar qurmağa həvəsliyəm.',
    ' — увлечённый созданием ПО для решения реальных задач.',
  );
  String get aboutUsStartedHeading =>
      _t('How it started?', 'Necə başladı?', 'Как всё началось?');
  String get aboutUsStartedBody => _t(
    'My development journey began out of a simple desire to make everyday tasks — looking up classrooms, downloading lectures, tracking schedules, and digging around for student IDs — easier. These are the small, daily hassles we all deal with, but by simplifying them, our entire university experience becomes smoother. What started as an idea in front of a blank screen has evolved into the fully functional application you are using today. It was intentionally engineered to serve your core needs and bridge the gap between students and faculty administration. ',
    'Proqramlaşdırma yolçuluğum dərslik axtarmaq, mühazirə yükləmək, cədvəllərə baxmaq, tələbə biletini axtarmaq — kimi gündəlik tapşırıqları asanlaşdırmaq istəyindən başladı. Bunlar hamımızın yaşadığı kiçik, gündəlik çətinliklərdir, lakin onları sadələşdirmək bizim bütün universitet təcrübəmizi daha axıcı edir. Sade bir fikir kimi başlayan bu layihə, bu gün istifadə etdiyiniz tam funksional tətbiqə çevrildi. Program sizin əsas ehtiyyaclarınıza uyğun olaraq sizə xidmət göstərmək üçün özənlə hazırlanmışdır. ',
    'Мой путь разработчика начался с простого желания упростить повседневные задачи — найти аудиторию, скачать лекцию, следить за расписанием. Это маленькие ежедневные трудности, с которыми мы все сталкиваемся, но упрощая их, весь университетский опыт становится комфортнее. То, что началось как идея перед пустым экраном, превратилось в полноценное приложение, которым вы пользуетесь сегодня. ',
  );
  String get aboutUsStartedItalic => _t(
    "Let's redefine our university experience together.",
    'Gəlin universitet həyatımızı birgə yenidən inşa edək.',
    'Давайте вместе переосмыслим наш университетский опыт.',
  );

  // ── Developer Card ────────────────────────────────────────────────────────
  String get developerGreeting =>
      _t("Hey there! I'm,", 'Salam! Mən,', 'Привет! Я,');
  String get developerSubtitle => _t(
    'a.k.a The Developer of This App',
    'həmçinin Bu Tətbiqin Yaradıcısı',
    'она же Разработчик этого приложения',
  );
  String get developerRoleTags => _t(
    'Junior · Full-Stack · Developer',
    'Junior · Full-Stack · Proqramçı',
    'Junior · Full-Stack · Разработчик',
  );

  // ── Footer ────────────────────────────────────────────────────────────────
  String get footerCopyright => _t(
    '© 2026 Zümrüd · UNEC Assistant',
    '© 2026 Zümrüd · UNEC Köməkçi',
    '© 2026 Zümrüd · UNEC Помощник',
  );
  String get footerRights =>
      _t('All rights reserved', 'Bütün hüquqlar qorunur', 'Все права защищены');
  String get footerMadeWithPre =>
      _t('This app was made ', 'Bu tətbiq ', 'Это приложение создано ');
  String get footerMadeWithItalic =>
      _t('for UNEC students', 'UNEC tələbələri üçün', 'для студентов UNEC');
  String get footerMadeWithPost =>
      _t(' with love <3', ' sevgi ilə hazırlanmışdır <3', ' с любовью <3');

  // ── Dialogs ───────────────────────────────────────────────────────────────
  String dialogOpenTitle(String platform) =>
      _t('Open $platform?', '$platform-ı aç?', 'Открыть $platform?');
  String dialogOpenBody(String platform) => _t(
    "You'll be redirected to $platform to contact the developer.",
    'Tərtibatçı ilə əlaqə saxlamaq üçün $platform-a yönləndiriləcəksiniz.',
    'Вас перенаправят в $platform для связи с разработчиком.',
  );
  String get dialogCancel => _t('Cancel', 'Ləğv et', 'Отмена');
  String get dialogOpen => _t('Open', 'Aç', 'Открыть');
  String get dialogDiscardTitle =>
      _t('Discard changes?', 'Dəyişiklikləri ləğv et?', 'Отменить изменения?');
  String get dialogDiscardBody => _t(
    'If you go back now, your post draft will be lost.',
    'İndi geri qayıtsanız, yazı layihəniz silinəcək.',
    'Если вы вернётесь сейчас, черновик записи будет удалён.',
  );
  String get dialogDiscard => _t('Discard', 'Sil', 'Удалить');

  // ── Profile Pop-up ────────────────────────────────────────────────────────
  String get popupManageAccount => _t(
    'Manage your Account',
    'Hesabınızı İdarə Edin',
    'Управление Аккаунтом',
  );
  String get popupAddAccount =>
      _t('Add another account', 'Başqa hesab əlavə et', 'Добавить аккаунт');
  String get popupSignOut => _t('Sign out', 'Çıxış et', 'Выйти');
  String get popupPrivacyPolicy =>
      _t('Privacy Policy', 'Məxfilik Siyasəti', 'Политика Конфиденциальности');
  String get popupTermsOfService =>
      _t('Terms of Service', 'Xidmət Şərtləri', 'Условия Использования');

  // ── Smart Sync ────────────────────────────────────────────────────────────
  String get smartSyncTitle =>
      _t('Smart Sync', 'Ağıllı Sinxronizasiya', 'Умная Синхронизация');
  String get smartSyncDesc => _t(
    "Automatically download and update your class files so you're always prepared.",
    'Sinif fayllarınızı avtomatik yükləyir və yeniləyir ki, dərsə həmişə hazır olasınız.',
    'Автоматически загружайте и обновляйте файлы, чтобы всегда быть готовыми.',
  );
  String get smartSyncDownloadPrefs =>
      _t('Download Preferences', 'Yükləmə Seçimləri', 'Настройки Загрузки');
  String get smartSyncWhichFiles => _t(
    'Select which files you want to keep up-to-date:',
    'Aktual saxlamaq istədiyiniz faylları seçin:',
    'Выберите файлы, которые нужно поддерживать актуальными:',
  );
  String get smartSyncCurrentClass =>
      _t('Current Class', 'Cari Dərs', 'Текущее Занятие');
  String get smartSyncCurrentBadge => _t(
    '(Highly Recommended)',
    '(Çox Tövsiyə Edilir)',
    '(Настоятельно Рекомендуется)',
  );
  String get smartSyncCurrentDesc => _t(
    'Always be prepared for class. Downloads essential files 30 minutes before lesson.',
    'Həmişə dərsliyə hazır olun. Dərsdən 30 dəqiqə əvvəl vacib faylları yükləyir.',
    'Всегда будьте готовы к занятию. Загружает файлы за 30 минут до урока.',
  );
  String get smartSyncUpcomingClass =>
      _t('Upcoming Class', 'Gözlənilən Dərs', 'Предстоящее Занятие');
  String get smartSyncUpcomingDesc => _t(
    "Get a head start on next class's materials.",
    'Növbəti dərsin materiallarına öncədən başlayın.',
    'Заранее ознакомьтесь с материалами следующего занятия.',
  );
  String get smartSyncPreviousClass =>
      _t('Previous Class', 'Əvvəlki Dərs', 'Предыдущее Занятие');
  String get smartSyncPreviousDesc => _t(
    "Keep last class's file for quick review.",
    'Sürətli nəzərdən keçirmək üçün son dərsin faylını saxlayın.',
    'Сохраняйте файл последнего занятия для быстрого просмотра.',
  );
  String get smartSyncFileTypes => _t(
    'Select types of files to download:',
    'Yükləmək üçün fayl növlərini seçin:',
    'Выберите типы файлов для загрузки:',
  );
  String get smartSyncLecture => _t('Lecture', 'Mühazirə', 'Лекция');
  String get smartSyncPresentation =>
      _t('Presentation', 'Prezentasiya', 'Презентация');
  String get smartSyncSeminar => _t('Seminar', 'Seminar', 'Семинар');
  String get smartSyncOtherFiles =>
      _t('Other Files', 'Digər Fayllar', 'Другие Файлы');

  // ── Feedback Card ─────────────────────────────────────────────────────────
  String get feedbackToFaculty => _t('To Faculty', 'Fakültəyə', 'Факультету');
  String get feedbackToDev =>
      _t('To Developer Team', 'Proqramçı Komandasına', 'Команде Разработчиков');
  String get feedbackToOther => _t('To Other', 'Digərinə', 'Другому');
  String get feedbackHint => _t(
    'Write your feedback here...',
    'Rəyinizi buraya yazın...',
    'Напишите ваш отзыв здесь...',
  );
  String get feedbackPrivacyNote1 =>
      _t('Your information is ', 'Məlumatlarınız ', 'Ваши данные ');
  String get feedbackPrivacyNeverShared =>
      _t('never shared', 'heç vaxt paylaşılmır', 'никогда не передаются');
  String get feedbackPrivacyNote2 => _t(
    '. All feedbacks are completely ',
    '. Bütün rəylər tamamilə ',
    '. Все отзывы полностью ',
  );
  String get feedbackPrivacyAnonymous =>
      _t('anonymous', 'anonimdir', 'анонимны');
  String get feedbackPrivacyNote3 => _t(
    ' and used only for improvement.',
    ' və yalnız inkişaf üçün istifadə olunur.',
    ' и используются только для улучшения.',
  );
  String get feedbackSubmit => _t('Submit', 'Göndər', 'Отправить');
  String get feedbackLearnMore => _t(
    'Learn more about anonymous feedbacks',
    'Anonim rəylər haqqında daha çox öyrənin',
    'Узнать больше об анонимных отзывах',
  );

  // ── Buttons ───────────────────────────────────────────────────────────────
  String get btnNotesTitle => _t('Notes', 'Qeydlər', 'Заметки');
  String get btnNotesSub => _t(
    'To-do lists & quick notes',
    'Yapılacaqlar & sürətli qeydlər',
    'Списки дел и быстрые заметки',
  );

  // ── Month Abbreviations ───────────────────────────────────────────────────
  String get monthJan => _t('Jan', 'Yan', 'Янв');
  String get monthFeb => _t('Feb', 'Fev', 'Фев');
  String get monthMar => _t('Mar', 'Mar', 'Мар');
  String get monthApr => _t('Apr', 'Apr', 'Апр');
  String get monthMay => _t('May', 'May', 'Май');
  String get monthJun => _t('Jun', 'İyn', 'Июн');
  String get monthJul => _t('Jul', 'İyl', 'Июл');
  String get monthAug => _t('Aug', 'Avq', 'Авг');
  String get monthSep => _t('Sep', 'Sen', 'Сен');
  String get monthOct => _t('Oct', 'Okt', 'Окт');
  String get monthNov => _t('Nov', 'Noy', 'Ноя');
  String get monthDec => _t('Dec', 'Dek', 'Дек');

  List<String> get months => [
    monthJan,
    monthFeb,
    monthMar,
    monthApr,
    monthMay,
    monthJun,
    monthJul,
    monthAug,
    monthSep,
    monthOct,
    monthNov,
    monthDec,
  ];

  // ── Weekdays ──────────────────────────────────────────────────────────────
  String get weekdayMon => _t('Mon', 'B.e.', 'Пн');
  String get weekdayTue => _t('Tue', 'Ç.a.', 'Вт');
  String get weekdayWed => _t('Wed', 'Çər', 'Ср');
  String get weekdayThu => _t('Thu', 'C.a.', 'Чт');
  String get weekdayFri => _t('Fri', 'Cüm', 'Пт');
  String get weekdaySat => _t('Sat', 'Şən', 'Сб');
  String get weekdaySun => _t('Sun', 'Baz', 'Вс');

  String get weekdayMonday => _t('Monday', 'Bazar ertəsi', 'Понедельник');
  String get weekdayTuesday => _t('Tuesday', 'Çərşənbə axşamı', 'Вторник');
  String get weekdayWednesday => _t('Wednesday', 'Çərşənbə', 'Среда');
  String get weekdayThursday => _t('Thursday', 'Cümə axşamı', 'Четверг');
  String get weekdayFriday => _t('Friday', 'Cümə', 'Пятница');
  String get weekdaySaturday => _t('Saturday', 'Şənbə', 'Суббота');
  String get weekdaySunday => _t('Sunday', 'Bazar', 'Воскресенье');

  List<String> get weekdays => [
    weekdayMonday,
    weekdayTuesday,
    weekdayWednesday,
    weekdayThursday,
    weekdayFriday,
    weekdaySaturday,
    weekdaySunday,
  ];

  List<String> get weekdaysShort => [
    weekdayMon,
    weekdayTue,
    weekdayWed,
    weekdayThu,
    weekdayFri,
    weekdaySat,
    weekdaySun,
  ];

  // ── Month Full Names ──────────────────────────────────────────────────────
  String get monthJanFull => _t('January', 'Yanvar', 'Январь');
  String get monthFebFull => _t('February', 'Fevral', 'Февраль');
  String get monthMarFull => _t('March', 'Mart', 'Март');
  String get monthAprFull => _t('April', 'Aprel', 'Апрель');
  String get monthMayFull => _t('May', 'May', 'Май');
  String get monthJunFull => _t('June', 'İyun', 'Июнь');
  String get monthJulFull => _t('July', 'İyul', 'Июль');
  String get monthAugFull => _t('August', 'Avqust', 'Август');
  String get monthSepFull => _t('September', 'Sentyabr', 'Сентябрь');
  String get monthOctFull => _t('October', 'Oktyabr', 'Октябрь');
  String get monthNovFull => _t('November', 'Noyabr', 'Ноябрь');
  String get monthDecFull => _t('December', 'Dekabr', 'Декабрь');

  List<String> get monthsFull => [
    monthJanFull,
    monthFebFull,
    monthMarFull,
    monthAprFull,
    monthMayFull,
    monthJunFull,
    monthJulFull,
    monthAugFull,
    monthSepFull,
    monthOctFull,
    monthNovFull,
    monthDecFull,
  ];

  // ── Current Class Extended ────────────────────────────────────────────────
  String get currentClassActive => _t('Active', 'Aktiv', 'Активно');
  String get currentClassNext =>
      _t('Next class', 'Növbəti dərs', 'Следующее занятие');
  String get currentClassComingUp =>
      _t('Coming up', 'Yaxınlaşır', 'Приближается');
  String get currentClassNoUpcoming => _t(
    'No upcoming classes in your schedule',
    'Cədvəlinizdə gözlənilən dərs yoxdur',
    'В вашем расписании нет предстоящих занятий',
  );
  String get currentClassTakesPlaceTomorrow => _t(
    'This class takes place tomorrow',
    'Bu dərs sabah olacaq',
    'Это занятие состоится завтра',
  );

  // ── Teaching Materials Extended ───────────────────────────────────────────
  String get teachingMaterialsNoMaterials =>
      _t('No materials yet', 'Hələ material yoxdur', 'Пока нет материалов');
  String get teachingMaterialsSeeAll =>
      _t('See all', 'Hamısına bax', 'Смотреть все');
  String get teachingMaterialsBundleCurrent => _t(
    'Materials bundle for current class :',
    'Cari dərs üçün material paketi :',
    'Пакет материалов для текущего занятия :',
  );
  String get teachingMaterialsDownloadBundle =>
      _t('Download Bundle', 'Paketi Yüklə', 'Скачать Пакет');
  String get teachingMaterialsBundleIncluding =>
      _t('Bundle including :', 'Paketə daxildir :', 'В пакет входит :');
  String get teachingMaterialsNoFiles => _t(
    'No files in this bundle',
    'Bu paketdə fayl yoxdur',
    'В этом пакете нет файлов',
  );

  // ── Attendance Card Extended ──────────────────────────────────────────────
  String get attendanceSafeText1 =>
      _t('You are safe. ', 'Təhlükəsizsiniz. ', 'Вы в безопасности. ');
  String get attendanceSafeText2 =>
      _t('Less than 50%', '50%-dən az', 'Менее 50%');
  String get attendanceSafeText3 => _t(
    ' of your absence allowance has been used. Use the rest wisely.',
    ' qayıb hüququnuz istifadə olunub. Qalanını diqqətli istifadə edin.',
    ' вашего лимита пропусков использовано. Используйте остаток с умом.',
  );

  String get attendanceCautionText1 =>
      _t('Caution. ', 'Diqqət. ', 'Внимание. ');
  String get attendanceCautionText2 =>
      _t('More than 50%', '50%-dən çox', 'Более 50%');
  String get attendanceCautionText3 => _t(
    ' of your absence allowance has been used. Use the rest wisely.',
    ' qayıb hüququnuz istifadə olunub. Qalanını diqqətli istifadə edin.',
    ' вашего лимита пропусков использовано. Используйте остаток с умом.',
  );

  String get attendanceDangerText1 => _t(
    'You have reached your limit. Any further absences will result in a ',
    'Limitə çatdınız. Bundan sonrakı hər hansı qayıb ',
    'Вы достигли лимита. Любые дальнейшие пропуски приведут к ',
  );
  String get attendanceDangerText2 =>
      _t('course failure.', 'kəsilməyə səbəb olacaq.', 'провалу курса.');

  // ── Attendance Screen ─────────────────────────────────────────────────────
  String get attendanceScreenTitle =>
      _t('Attendance', 'Davamiyyət', 'Посещаемость');
  String get attendanceNeedsAttention =>
      _t('Needs attention', 'Diqqət tələb edir', 'Требует внимания');
  String get attendanceAllSubjects =>
      _t('All subjects', 'Bütün fənlər', 'Все предметы');

  String get subjectsBtnTitle => _t('Subjects', 'Fənnlər', 'Предметы');
  String get subjectsBtnSub => _t(
    'For the full academic semester',
    'Tam akademik semestr üçün',
    'На полный учебный семестр',
  );
  String get subjectsBtnGradesMaterials =>
      _t('Grades · Materials', 'Qiymətlər · Materiallar', 'Оценки · Материалы');
  String get subjectsBtnTeachingMaterials =>
      _t('Teaching Materials', 'Tədris Materialları', 'Учебные Материалы');
  String get subjectsBtnTeachingMaterialsSub => _t(
    'Lectures, seminars & tests',
    'Mühazirələr, seminarlar və testlər',
    'Лекции, семинары и тесты',
  );
  String get subjectsBtnGrades => _t('Grades', 'Qiymətlər', 'Оценки');
  String get subjectsBtnGradesSub => _t(
    'Seminars & exam results',
    'Seminarlar və imtahan nəticələri',
    'Семинары и результаты экзаменов',
  );

  String get subjectsScreenTitle => _t('Subjects', 'Fənlər', 'Предметы');
  String subjectsAllSubjects(int count) => _t(
    'All subjects  $count',
    'Bütün fənlər  $count',
    'Все предметы  $count',
  );

  String get subjectsStartingIn => _t('Starting in', 'Başlayır', 'Начало в');
  String get subjectsEndingIn => _t('Ending in', 'Bitir', 'Конец в');
  String get subjectsTotalCredits =>
      _t('Total Credits', 'Ümumi kredit', 'Всего кредитов');
  String get subjectsTotalSubjects =>
      _t('Total Subjects', 'Ümumi fənn', 'Всего предметов');
  String get subjectsTotalHours =>
      _t('Total Hours', 'Ümumi saat', 'Всего часов');
  String get subjectsAuditoriumHours =>
      _t('Auditorium Hours', 'Auditoriya saatı', 'Аудиторные часы');
  String get subjectsInThisSemester =>
      _t('in this semester', 'bu semestrdə', 'в этом семестре');
  String get subjectsLectures => _t('Lectures', 'Mühazirələr', 'Лекции');
  String get subjectsSeminars => _t('Seminars', 'Seminarlar', 'Семинары');
  String get subjectsLaboratories =>
      _t('Laboratories', 'Laboratoriyalar', 'Лабораторные');

  String get subjectsDownloadCurriculumTitle => _t(
    'Download & See Curriculum Plan',
    'Tədris planını yüklə və bax',
    'Скачать и посмотреть учебный план',
  );
  String get subjectsDownloadCurriculumDesc => _t(
    '4 year - full curriculum plan of your major',
    'İxtisasınızın 4 illik tam tədris planı',
    'Полный учебный план вашей специальности на 4 года',
  );

  // ── Subject Details & Cards ───────────────────────────────────────────────
  String get subjectDetailOpenGrades =>
      _t('Open Grades', 'Qiymətləri aç', 'Открыть оценки');
  String get subjectDetailForThisSubject =>
      _t('For this subject', 'Bu fənn üzrə', 'По этому предмету');
  String get subjectDetailOpenMaterials =>
      _t('Open Materials', 'Materialları aç', 'Открыть материалы');

  String get subjectTeacherTitle => _t('TEACHER', 'MÜƏLLİM', 'ПРЕПОДАВАТЕЛЬ');
  String get subjectHoursTitle => _t('HOURS', 'SAATLAR', 'ЧАСЫ');
  String get subjectHoursBreakdown =>
      _t('BREAKDOWN', 'BÖLÜŞDÜRMƏ', 'РАСПРЕДЕЛЕНИЕ');

  String get subjectClassLoadTitle => _t('CLASS LOAD', 'DƏRS YÜKÜ', 'НАГРУЗКА');
  String get subjectClassLoadSessions =>
      _t('sessions/\nweek', 'dərs/\nhəftə', 'занятий/\nнеделю');
  String get subjectClassLoadHrs =>
      _t('hrs/\nweek', 'saat/\nhəftə', 'час/\nнеделю');
  String get subjectClassLoadDays =>
      _t('class\ndays', 'dərs\ngünləri', 'учебных\nдней');

  String get subjectCreditTitle =>
      _t('SUBJECT CREDIT', 'FƏNN KREDİTİ', 'КРЕДИТЫ ПРЕДМЕТА');
  String get subjectCreditWhatAre =>
      _t('What are credits?', 'Kreditlər nədir?', 'Что такое кредиты?');
  String get subjectCreditDesc1 => _t(
    'Educational units measuring course ',
    'Kursun iş yükünü ölçən ',
    'Образовательные единицы, измеряющие ',
  );
  String get subjectCreditDesc2 =>
      _t('workload', 'tədris vahidləri', 'учебную нагрузку');
  String get subjectCreditDesc3 => _t(
    '. Subjects with more credits have a greater impact on your overall ',
    '. Daha çox krediti olan fənlər ümumi qiymətlərinizə daha çox ',
    '. Предметы с большим количеством кредитов сильнее влияют на ваши общие ',
  );
  String get subjectCreditDesc4 => _t('grades.', 'təsir edir.', 'оценки.');

  String get subjectMidtermTitle =>
      _t('Midterm exam', 'Aralıq imtahan', 'Промежуточный экзамен');
  String get subjectMidtermNotYet => _t('Not Yet', 'Hələ yox', 'Пока нет');
  String get subjectMidtermOpen => _t(
    'Open in Unec Cabinet',
    'Unec Kabinet-də aç',
    'Открыть в Unec Cabinet',
  );
  String get subjectMidtermOpenDesc => _t(
    'See your results in Unec Cabinet',
    'Nəticələrinizi Unec Kabinet-də görün',
    'Посмотреть результаты в Unec Cabinet',
  );

  String get subjectSeminarTitle => _t('Seminars', 'Seminarlar', 'Семинары');
  String get subjectSeminarNoneGraded => _t(
    'no seminars graded',
    'qiymətləndirilmiş seminar yoxdur',
    'нет оцененных семинаров',
  );
  String get subjectSeminarGradedSuffix =>
      _t('seminars graded', 'seminar qiymətləndirilib', 'семинаров оценено');

  String get subjectFinalTitle =>
      _t('Final exam', 'Final imtahanı', 'Итоговый экзамен');
  String get subjectFinalScore => _t('score', 'nəticə', 'балл');

  String get subjectMaterialsNoMaterials => _t(
    'No materials available yet',
    'Hələ heç bir material yoxdur',
    'Пока нет доступных материалов',
  );
  String subjectMaterialsBundleFor(String label) => _t(
    'Materials bundle for $label:',
    '$label üçün material paketi:',
    'Пакет материалов для $label:',
  );

  // ── Grade Calculator Screen & Components ───────────────────────────────────
  String get gradeCalcScreenTitle => _t(
    'Grade Goal Calculator',
    'Hədəf Bal Kalkulyatoru',
    'Калькулятор Целевой Оценки',
  );
  String get gradeCalcTitle => _t(
    'Grade Goal Calculator',
    'Hədəf Bal Kalkulyatoru',
    'Калькулятор Целевой Оценки',
  );
  String get gradeCalcSubtitle => _t(
    'Select a target grade and see exactly what you need to achieve it.',
    'Hədəf qiyməti seçin və ona nail olmaq üçün nə lazım olduğunu dəqiqliklə görün.',
    'Выберите целевую оценку и узнайте, что именно вам нужно для её достижения.',
  );
  String get gradeCalcFor => _t('CALCULATE FOR', 'HESABLA', 'РАССЧИТАТЬ ДЛЯ');
  String get gradeCalcChooseSubject => _t(
    'Choose a Subject you want to calculate...',
    'Hesablamaq istədiyiniz fənni seçin...',
    'Выберите предмет для расчета...',
  );
  String get gradeCalcWantToAchieve =>
      _t('I want to achieve', 'Mən nail olmaq istəyirəm', 'Я хочу достичь');
  String get gradeCalcBtn => _t('CALCULATE', 'HESABLA', 'РАССЧИТАТЬ');
  String get gradeCalcCurrentScore =>
      _t('Current\nScore', 'Cari\nNəticə', 'Текущий\nБалл');
  String get gradeCalcPtsSoFar =>
      _t(' pts so far', ' xal (indiyə kimi)', ' баллов пока');
  String get gradeCalcHave => _t('Have: ', 'Var: ', 'Есть: ');
  String get gradeCalcNeed => _t('Need: ', 'Lazımdır: ', 'Нужно: ');
  String gradeCalcPtsNeededToReach(int target) => _t(
    'pts needed to reach $target',
    '$target nəticəsinə çatmaq üçün lazımdır',
    'баллов нужно для достижения $target',
  );

  // ── Smart Sync Screen & Components ─────────────────────────────────────────
  String get showInFilesBtnTitle => _t(
    'Show in File Manager',
    'Fayl Menecerində göstər',
    'Показать в Файловом Менеджере',
  );
  String get showInFilesBtnSub => _t(
    'See & manage downloaded files',
    'Yüklənmiş fayllara baxın və idarə edin',
    'Смотрите и управляйте загруженными файлами',
  );
  String get smartSyncBtnTitle => _t(
    'Manage & See Smart Sync Files',
    'Ağıllı Sinxronizasiya fayllarını idarə et',
    'Управление файлами Умной Синхронизации',
  );
  String get smartSyncBtnSub => _t(
    'Set your Auto-Download preferences',
    'Avtomatik yükləmə tənzimləmələri',
    'Настройки автозагрузки',
  );

  // ── Schedule Screen & Calendar ─────────────────────────────────────────────
  String get scheduleTodaysPlans =>
      _t('Today\'s plans', 'Bugünkü planlar', 'Планы на сегодня');
  String get scheduleCalendar => _t('Calendar', 'Təqvim', 'Календарь');
  String get scheduleMonthView => _t('Month', 'Ay', 'Месяц');
  String get scheduleWeekView => _t('Week', 'Həftə', 'Неделя');
  String get scheduleDayView => _t('Day', 'Gün', 'День');
  String get scheduleWeekTop => _t('Top week', 'Üst həftə', 'Верхняя неделя');
  String get scheduleWeekBottom =>
      _t('Bottom week', 'Alt həftə', 'Нижняя неделя');
  String get scheduleHbd => _t('🎂 HBD', '🎂 HBD', '🎂 С ДР');
  String get scheduleClasses => _t('classes', 'dərs', 'занятий');
  String get schedulePersonalPlans =>
      _t('personal plans', 'şəxsi plan', 'личных планов');
  String scheduleMinutesLater(int m) =>
      _t('$m minutes later', '$m dəqiqə sonra', 'через $m минут');
  String get scheduleNoUpcomingEventsToday => _t(
    'No upcoming events today',
    'Bu gün üçün başqa plan yoxdur',
    'На сегодня больше нет событий',
  );

  // ── Event Editor Sheet ────────────────────────────────────────────────────
  String get eventEditTitle =>
      _t('Edit event', 'Planı redaktə et', 'Редактировать событие');
  String get eventNewTitle => _t('New event', 'Yeni Plan', 'Новое событие');
  String get eventFieldTitle => _t('Title', 'Başlıq', 'Название');
  String get eventFieldDescription => _t('Description', 'Təsvir', 'Описание');
  String get eventFieldLocation => _t('Location', 'Məkan', 'Место');
  String get eventFieldDate => _t('Date', 'Tarix', 'Дата');
  String get eventFieldStart => _t('Start', 'Başlama', 'Начало');
  String get eventFieldEnd => _t('End', 'Bitmə', 'Конец');
  String get eventCategory => _t('Category', 'Kateqoriya', 'Категория');
  String get eventCatClass => _t('Class', 'Dərs', 'Занятие');
  String get eventCatPersonal => _t('Personal', 'Şəxsi', 'Личное');
  String get eventCatExam => _t('Exam', 'İmtahan', 'Экзамен');
  String get eventBtnSave =>
      _t('Save changes', 'Dəyişiklikləri saxla', 'Сохранить изменения');
  String get eventBtnCreate =>
      _t('Create event', 'Plan yarat', 'Создать событие');
  String get eventSubtypeLecture => _t('Lecture', 'Mühazirə', 'Лекция');
  // ── Create Post Screen ─────────────────────────────────────────────────────
  String get createPostTitle =>
      _t('Create Post', 'Paylaşım Yarat', 'Создать Пост');
  String get createPostWaitingApproval =>
      _t('Waiting Approval', 'Təsdiq Gözləyir', 'Ожидает Одобрения');
  String get createPostSharedPosts =>
      _t('Shared Posts', 'Paylaşılanlar', 'Поделились');
  String get createPostFillFields => _t(
    'Please fill all fields',
    'Zəhmət olmasa bütün sahələri doldurun',
    'Пожалуйста, заполните все поля',
  );
  String get createPostInvalidEmail => _t(
    'Please enter a valid email',
    'Zəhmət olmasa düzgün e-poçt daxil edin',
    'Пожалуйста, введите действительный email',
  );
  String get createPostRequestSentTitle =>
      _t('Request Sent', 'Sorğu Göndərildi', 'Запрос Отправлен');
  String get createPostSuccessDesc => _t(
    'Your post has been sent to audits (zverdiyevaa9@gmail.com). You will be notified once it is approved.',
    'Paylaşımınız yoxlanışa (zverdiyevaa9@gmail.com) göndərildi. Təsdiqləndikdən sonra sizə bildiriş göndəriləcək.',
    'Ваш пост отправлен на проверку (zverdiyevaa9@gmail.com). Вы получите уведомление после одобрения.',
  );
  String get createPostOk => _t('OK', 'Oldu', 'ОК');
  String get createPostEditorTab => _t('Editor', 'Redaktor', 'Редактор');
  String get createPostWaitingTab => _t('Waiting', 'Gözləmədə', 'Ожидание');
  String get createPostSharedTab => _t('Shared', 'Paylaşılan', 'Поделились');
  String get createPostYourNamePlaceholder =>
      _t('Your Name', 'Adınız', 'Ваше Имя');
  String get createPostPreviewBodyPlaceholder => _t(
    'Your post content will appear here...',
    'Paylaşımınızın məzmunu burada görünəcək...',
    'Содержание вашего поста появится здесь...',
  );
  String get createPostSenderDetails =>
      _t('SENDER DETAILS', 'GÖNDƏRƏN BİLGİLƏRİ', 'ДАННЫЕ ОТПРАВИТЕЛЯ');
  String get createPostFullNameHint => _t('Full Name', 'Tam Ad', 'Полное Имя');
  String get createPostEmailHint =>
      _t('Your Email (Sender)', 'Sizin E-poçtunuz', 'Ваш Email');
  String get createPostPostContent =>
      _t('POST CONTENT', 'MƏZMUN', 'КОНТЕНТ ПОСТА');
  String get createPostContentHint =>
      _t('What\'s on your mind?', 'Nə düşünürsünüz?', 'О чем вы думаете?');
  String get createPostLivePreview =>
      _t('LIVE PREVIEW', 'CANLI BAXIŞ', 'ПРЕДПРОСМОТР');
  String get createPostSelectSignatureHint => _t(
    'Select saved signature',
    'Yadda saxlanılan imzanı seçin',
    'Выберите сохраненную подпись',
  );
  String get createPostPendingEmptyTitle => _t(
    'Waiting for your first approval?',
    'İlk təsdiqinizi gözləyirsiniz?',
    'Ждете первого одобрения?',
  );
  String get createPostPendingEmptyDesc => _t(
    'Send a post for review and it will appear here!',
    'Yoxlanış üçün paylaşım göndərin və o burada görünəcək!',
    'Отправьте пост на проверку, и он появится здесь!',
  );
  String get createPostSharedEmptyTitle => _t(
    'No shared posts yet.',
    'Hələ paylaşılan məzmun yoxdur.',
    'Пока нет опубликованных постов.',
  );
  String get createPostSharedEmptyDesc => _t(
    'Create your first post now!',
    'İlk paylaşımınızı indi yaradın!',
    'Создайте свой первый пост сейчас!',
  );
  String get createPostGoToEditor =>
      _t('Go to Editor', 'Redaktora Keç', 'Перейти в Редактор');
  String createPostDaysAgo(int days) =>
      _t('$days d ago', '$days g əvvəl', '$days д назад');
  String createPostHoursAgo(int hours) =>
      _t('$hours h ago', '$hours s əvvəl', '$hours ч назад');
  String createPostMinsAgo(int mins) =>
      _t('$mins m ago', '$mins d əvvəl', '$mins м назад');
  String get createPostJustNow => _t('Just now', 'İndicə', 'Только что');
  String get createPostAuditInfoTitle => _t(
    'Audit Approval Process',
    'Yoxlanış və Təsdiq Prosesi',
    'Процесс Одобрения',
  );
  String get createPostAuditInfoDesc => _t(
    'All posts are sent to our team for verification. Once approved, your post will be visible in the Discover feed.',
    'Bütün paylaşımlar təsdiqlənmək üçün komandamıza göndərilir. Təsdiqləndikdən sonra Kəşfet bölməsində görünəcək.',
    'Все посты отправляются нашей команде на проверку. После одобрения ваш пост появится в ленте.',
  );
  String get createPostAttachmentNotImpl => _t(
    'Image selection will be implemented soon',
    'Şəkil seçimi tezliklə əlavə ediləcək',
    'Выбор изображения скоро будет добавлен',
  );
  String get createPostAddAttachment =>
      _t('Add Attachment', 'Əlavə Et', 'Добавить вложение');
  String get createPostSubmitBtn =>
      _t('Send for Approval', 'Təsdiqə Göndər', 'Отправить на проверку');
  String get createPostSaveSignature =>
      _t('Save as signature', 'İmza kimi yadda saxla', 'Сохранить как подпись');
  String get createPostCatOfficial =>
      _t('Official Announcement', 'Rəsmi Elan', 'Официальное Объявление');
  String get createPostCatClub =>
      _t('Club Update', 'Klub Xəbəri', 'Обновление Клуба');
  String get createPostCatDev => _t(
    'Dev Team Log',
    'Dev Komandası Hesabatı',
    'Отчет Команды Разработчиков',
  );

  // ── Change Password Screen ────────────────────────────────────────────────
  String get changePassTitle =>
      _t('Change Password', 'Şifrəni Dəyiş', 'Изменить Пароль');
  String get changePassHeader => _t(
    'Set a new password',
    'Yeni şifrə təyin edin',
    'Установите новый пароль',
  );
  String get changePassSubtitle => _t(
    'This password does not affect your\nUnec Kabinet Password',
    'Bu şifrə sizin Unec Kabinet\nşifrənizə təsir etmir',
    'Этот пароль не влияет на ваш\nпароль от Unec Kabinet',
  );
  String get changePassCurrent =>
      _t('Current password', 'Cari şifrə', 'Текущий пароль');
  String get changePassNew => _t('New password', 'Yeni şifrə', 'Новый пароль');
  String get changePassConfirm =>
      _t('Confirm password', 'Şifrəni təsdiqlə', 'Подтвердите пароль');

  String get changePassEnterHint =>
      _t('Enter password', 'Şifrəni daxil edin', 'Введите пароль');
  String get changePassRequirements =>
      _t('Password requirements', 'Şifrə tələbləri', 'Требования к паролю');
  String get changePassReqLength => _t(
    '8-32 characters long',
    '8-32 simvol uzunluğunda',
    'От 8 до 32 символов',
  );
  String get changePassReqUppercase => _t(
    'One uppercase letter (A-Z)',
    'Bir böyük hərf (A-Z)',
    'Одна заглавная буква (A-Z)',
  );
  String get changePassReqLowercase => _t(
    'One lowercase letter (a-z)',
    'Bir kiçik hərf (a-z)',
    'Одна строчная буква (a-z)',
  );
  String get changePassReqNumber => _t('One number', 'Bir rəqəm', 'Одна цифра');
  String get changePassReqSpecial => _t(
    'One special character (!@#\$...)',
    'Bir xüsusi simvol (!@#\$...)',
    'Один спецсимвол (!@#\$...)',
  );
  String get changePassReqDifferent => _t(
    'Different from last 3 passwords',
    'Son 3 şifrədən fərqli',
    'Отличается от последних 3 паролей',
  );
  String get changePassUpdateBtn =>
      _t('Update password', 'Şifrəni yenilə', 'Обновить пароль');
  String get changePassForgot => _t(
    'Forgot current password?',
    'Cari şifrəni unutmusunuz?',
    'Забыли текущий пароль?',
  );
  String get changePassTrouble => _t(
    'Having troubles with your Unec Kabinet password?',
    'Unec Kabinet şifrənizlə bağlı probleminiz var?',
    'Проблемы с паролем от Unec Kabinet?',
  );
  String get changePassErrorMismatch => _t(
    'Passwords do not match',
    'Şifrələr uyğun gəlmir',
    'Пароли не совпадают',
  );
  String get changePassSuccess => _t(
    'Password changed successfully!',
    'Şifrə uğurla dəyişdirildi!',
    'Пароль успешно изменён!',
  );
  String get changePassErrorLocked => _t(
    'Account temporarily locked. Try again later.',
    'Hesab müvəqqəti kilidləndi. Daha sonra yenidən cəhd edin.',
    'Аккаунт временно заблокирован. Попробуйте позже.',
  );
  String changePassErrorIncorrect(int attempts) => _t(
    'Incorrect current password. $attempts attempts remaining.',
    'Cari şifrə yanlışdır. $attempts cəhd qaldı.',
    'Неверный текущий пароль. Осталось попыток: $attempts.',
  );
  String changePassCooldown(int minutes, String seconds) => _t(
    'Security cooldown: $minutes:$seconds remaining',
    'Təhlükəsizlik fasiləsi: $minutes:$seconds qaldı',
    'Ожидание безопасности: осталось $minutes:$seconds',
  );

  String get lectureWord => _t('Lecture', 'Mühazirə', 'Лекция');
  String localizeLectureLabel(String label) {
    String result = label;
    if (result.contains('Lecture')) {
      result = result.replaceAll('Lecture', lectureWord);
    }
    return result;
  }

  String localizeDateString(String dateStr) {
    final monthsEn = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    for (int i = 0; i < monthsEn.length; i++) {
      if (dateStr.contains(monthsEn[i])) {
        return dateStr.replaceFirst(monthsEn[i], months[i]);
      }
    }
    return dateStr;
  }

  // ── Student ID Card ────────────────────────────────────────────────────────
  String get studentCardTitle => _t('Student ID Card', 'Tələbə ID Kartı', 'Студенческий Билет');
  String get studentCardTapToFlip => _t('Tap card to flip front/back', 'Ön/arxa tərəfi çevirmək üçün karta toxunun', 'Нажмите на карту, чтобы перевернуть');
  String get studentCardSurpriseVibe => _t('Surprise Vibe', 'Sürpriz Aura', 'Сюрприз Атмосфера');
  String get studentCardThemeTitle => _t('Card Theme', 'Kart Teması', 'Тема Карты');
  String get studentCardThemeSubtitle => _t('Select your signature campus color vibe', 'Özünəməxsus kampüs rəng vibe-ınızı seçin', 'Выберите свой фирменный цвет кампуса');
  String get studentCardAvatarTitle => _t('Avatar & Photo', 'Avatar və Şəkil', 'Аватар и Фото');
  String get studentCardAvatarSubtitle => _t('Choose your card photo or clean initials', 'Kart şəklinizi və ya təmiz inisiallarınızı seçin', 'Выберите фото для карты или чистые инициалы');
  String get studentCardInitials => _t('Initials', 'İnisiallar', 'Инициалы');
  String get studentCardPhoto => _t('Photo', 'Şəkil', 'Фото');
  String get studentCardMascot => _t('Mascot', 'Maskot', 'Маскот');
  String get studentCardMore => _t('More', 'Daha Çox', 'Больше');
  String get studentCardMottoTitle => _t('Campus Motto', 'Kampüs Mottosu', 'Девиз Кампуса');
  String get studentCardMottoSubtitle => _t('A custom quote displayed right on your card', 'Kartınızda görünən xüsusi bir sitat', 'Пользовательская цитата, отображаемая прямо на вашей карте');
  String get studentCardMottoHint => _t('Type your campus motto...', 'Kampüs mottonuzu yazın...', 'Введите ваш девиз кампуса...');
  String get studentCardQuickVibes => _t('QUICK VIBES', 'SÜRƏTLİ VIBELAR', 'БЫСТРЫЕ АТМОСФЕРЫ');
  String get studentCardClearQuote => _t('✨ Clear quote', '✨ Sitatı təmizlə', '✨ Очистить цитату');
  String get studentCardSaveBtn => _t('Save & Return', 'Yadda saxla və Qayıt', 'Сохранить и Вернуться');
  String get studentCardUnsavedTitle => _t('Unsaved Changes', 'Yadda Saxlanmamış Dəyişikliklər', 'Несохраненные Изменения');
  String get studentCardUnsavedDesc => _t(
        'You have unsaved changes to your student card. If you leave now, your customizations will be discarded.',
        'Tələbə kartınızda yadda saxlanmamış dəyişikliklər var. İndi çıxsanız, dəyişiklikləriniz ləğv ediləcək.',
        'У вас есть несохраненные изменения в студенческом билете. Если вы уйдете сейчас, ваши изменения будут отменены.',
      );
  String get studentCardDiscardBtn => _t('Discard', 'Ləğv et', 'Отменить');
  String get studentCardKeepEditingBtn => _t('Keep Editing', 'Redaktəyə Davam Et', 'Продолжить Редактирование');
  String get studentCardChooseAvatar => _t('Choose Avatar', 'Avatar Seçin', 'Выберите Аватар');
  String get studentCardPhotoLabel => _t('Student Photo', 'Tələbə Şəkli', 'Фото Студента');
  String get studentCardMascotLabel => _t('UNEC Mascot', 'UNEC Maskotu', 'Маскот UNEC');
  String get studentCardUnecProfileLabel => _t('UNEC Profile', 'UNEC Profili', 'Профиль UNEC');

  String localizeClassDays(String classDays) {
    final daysEn = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    String result = classDays;
    for (int i = 0; i < daysEn.length; i++) {
      if (result.contains(daysEn[i])) {
        result = result.replaceAll(daysEn[i], weekdaysShort[i]);
      }
    }
    return result;
  }
}
