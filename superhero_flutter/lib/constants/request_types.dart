class RequestTypes {
  static const String TECHNOLOGY_CONNECTION = 'technologyConnection';
  static const String TECHNOLOGY_CONNECTION_BY_TIME_SCHEME =
      'technologyConnectionByTimeScheme';
  static const String TECHNOLOGY_CONNECTION_BY_ENERGY_REDISTRIBUTION =
      'technologyConnectionByEnergyRedistribution';
  static const String DOCUMENTS_RECOVERY = 'documentsRecovery';

  static getTypeValue(String type) {
    if (type == TECHNOLOGY_CONNECTION) {
      return 'Заявка на осуществление технологического присоединения';
    } else if (type == TECHNOLOGY_CONNECTION_BY_TIME_SCHEME) {
      return 'Заявка на осуществление технологического присоединения по временной схеме';
    } else if (type == TECHNOLOGY_CONNECTION_BY_ENERGY_REDISTRIBUTION) {
      return 'Заявка на осуществление технологического присоединения посредством перераспределения максимальной мощности';
    } else if (type == DOCUMENTS_RECOVERY) {
      return 'Заявка на восстановление (переоформление) документов';
    }

    return '';
  }
}
