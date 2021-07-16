
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:growth_app/model/survey_question.dart';
import 'package:growth_app/wellbeingscore.dart';

class SurveyController extends GetxController
with SingleGetTickerProviderMixin{


  late PageController _pageController;
  PageController get pageController => this._pageController;
  List<Question> _questions = sample_data
      .map(
        (question) => Question(
        id: question['id'],
        question: question['question'],
        options: question['options']),
  )
      .toList();
  List<Question> get questions => this._questions;

  // for more about obs please check documentation
  RxInt _questionNumber = 1.obs;
  RxInt get questionNumber => this._questionNumber;

  bool _isAnswered = false;
  bool get isAnswered => this._isAnswered;

  late int _selectedAns;
  int get selectedAns => this._selectedAns;

  bool _isFinished = false;
  bool get isFinished => this._isFinished;

  int _totalScore = 0;
  int get totalScore => this._totalScore;

  void resetSurvey(){
    _questionNumber.value = 1;
    _isFinished = false;
    _totalScore = 0;
    _selectedAns = 0;
    _isAnswered = false;

  }
  @override
  void onInit() {
    _pageController = PageController();
    super.onInit();
  }

  // // called just before the Controller is deleted from memory
  @override
  void onClose() {
    super.onClose();
    _pageController.dispose();
  }
  void addUpScore(Question question, int selectedIndex){
    _isAnswered = true;
    _selectedAns = selectedIndex;
    print(selectedAns);
    _totalScore = _totalScore + _selectedAns;
    print(_totalScore);
    _isAnswered = false;
    nextQuestion();

  }

  void nextQuestion() {
    if (_questionNumber.value != _questions.length) {
      _isAnswered = false;
      _pageController.nextPage(
          duration: Duration(milliseconds: 250), curve: Curves.ease);


    } else {

      _isFinished = true;


      _pageController.nextPage(
          duration: Duration(milliseconds: 250), curve: Curves.ease);


    }
  }
  void updateQnsNumber(int index){
    _questionNumber.value = index + 1;
  }
}