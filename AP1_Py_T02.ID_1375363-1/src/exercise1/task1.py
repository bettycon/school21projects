import asyncio
import random
import time
import os
import curses
from dataclasses import dataclass
from typing import List, Optional
from enum import Enum

# Константы
PHI = 1.618033988749  # Золотое сечение

class StudentStatus(Enum):
    QUEUE = "Очередь"
    PASSED = "Сдал"
    FAILED = "Провалил"

class ExaminerMood(Enum):
    BAD = "bad"
    GOOD = "good"
    NEUTRAL = "neutral"

@dataclass
class Student:
    name: str
    gender: str
    status: StudentStatus = StudentStatus.QUEUE
    finish_time: Optional[float] = None
    
class Question:
    def __init__(self, text: str):
        self.text = text
        self.words = text.split()
        self.correct_answers_count = 0
        
    def get_probabilities(self, is_male: bool):
        """Вычисляет вероятности выбора слов по закону золотого сечения"""
        n = len(self.words)
        if n == 0:
            return []
            
        probs = []
        remaining = 1.0
        
        for i in range(n - 1):
            if i == 0:
                prob = 1 / PHI
            else:
                prob = remaining / PHI
            probs.append(prob)
            remaining -= prob
        
        probs.append(remaining)
        
        # Для девочек инвертируем порядок
        if not is_male:
            probs.reverse()
            
        return probs

class Examiner:
    def __init__(self, name: str):
        self.name = name
        self.current_student: Optional[Student] = None
        self.total_students = 0
        self.failed_students = 0
        self.work_time = 0.0
        self.start_time = None
        self.is_on_lunch = False
        self.lunch_end_time = None
        
    def get_exam_duration(self):
        """Время экзамена зависит от длины имени"""
        name_len = len(self.name.split()[0])  # Берем только имя без пола
        return random.uniform(name_len - 1, name_len + 1)
        
    def choose_words_from_question(self, question: Question):
        """Экзаменатор выбирает правильные ответы"""
        words = question.words[:]
        correct_answers = []
        
        if words:
            chosen_word = random.choice(words)
            correct_answers.append(chosen_word)
            
            while len(correct_answers) < len(question.words) and random.random() < 1/3:
                remaining_words = [w for w in words if w not in correct_answers]
                if remaining_words:
                    chosen_word = random.choice(remaining_words)
                    correct_answers.append(chosen_word)
                else:
                    break
                    
        return correct_answers

class ExamSimulation:
    def __init__(self):
        self.students: List[Student] = []
        self.examiners: List[Examiner] = []
        self.questions: List[Question] = []
        self.student_queue = asyncio.Queue()
        self.start_time = None
        self.finished_students = []
        self.lock = asyncio.Lock()
        
    def load_data(self):
        """Загружает данные из файлов относительно директории скрипта"""
        script_dir = os.path.dirname(os.path.abspath(__file__))
        
        # Загружаем экзаменаторов
        examiners_path = os.path.join(script_dir, 'examiners.txt')
        try:
            with open(examiners_path, 'r', encoding='utf-8') as f:
                for line in f:
                    name = line.strip()
                    if name:
                        self.examiners.append(Examiner(name))
        except FileNotFoundError:
            print(f"Ошибка: Файл {examiners_path} не найден.")
            raise
        except Exception as e:
            print(f"Ошибка чтения examiners.txt: {e}")
            raise
        
        # Загружаем студентов
        students_path = os.path.join(script_dir, 'students.txt')
        try:
            with open(students_path, 'r', encoding='utf-8') as f:
                for line in f:
                    line = line.strip()
                    if line:
                        parts = line.split()
                        if len(parts) >= 2:
                            name = parts[0]
                            gender = parts[1]  # "М" или "Ж"
                            self.students.append(Student(name, gender))
        except FileNotFoundError:
            print(f"Ошибка: Файл {students_path} не найден.")
            raise
        except Exception as e:
            print(f"Ошибка чтения students.txt: {e}")
            raise
        
        # Загружаем вопросы
        questions_path = os.path.join(script_dir, 'questions.txt')
        try:
            with open(questions_path, 'r', encoding='utf-8') as f:
                for line in f:
                    question_text = line.strip()
                    if question_text:
                        self.questions.append(Question(question_text))
        except FileNotFoundError:
            print(f"Ошибка: Файл {questions_path} не найден.")
            raise
        except Exception as e:
            print(f"Ошибка чтения questions.txt: {e}")
            raise
    
    async def fill_student_queue(self):
        """Заполняет очередь студентов"""
        for student in self.students:
            await self.student_queue.put(student)
    
    def student_answer(self, student: Student, question: Question):
        """Студент отвечает на вопрос"""
        is_male = student.gender == "М"  # Исправлено на "М" для мальчиков
        probabilities = question.get_probabilities(is_male)
        
        if not probabilities:
            return ""
            
        chosen_index = random.choices(range(len(question.words)), weights=probabilities)[0]
        return question.words[chosen_index]
    
    def evaluate_answer(self, student_answer: str, correct_answers: List[str]):
        """Проверяет правильность ответа"""
        return student_answer in correct_answers
    
    def get_examiner_mood(self):
        """Определяет настроение экзаменатора"""
        rand = random.random()
        if rand < 1/8:
            return ExaminerMood.BAD
        elif rand < 1/8 + 1/4:
            return ExaminerMood.GOOD
        else:
            return ExaminerMood.NEUTRAL
    
    async def examine_student(self, examiner: Examiner, student: Student):
        """Процесс сдачи экзамена одним студентом"""
        correct_count = 0
        total_questions = 3
        
        for _ in range(total_questions):
            if not self.questions:
                break
                
            question = random.choice(self.questions)
            correct_answers = examiner.choose_words_from_question(question)
            student_answer = self.student_answer(student, question)
            
            if self.evaluate_answer(student_answer, correct_answers):
                correct_count += 1
                question.correct_answers_count += 1
        
        mood = self.get_examiner_mood()
        
        if mood == ExaminerMood.BAD:
            passed = False
        elif mood == ExaminerMood.GOOD:
            passed = True
        else:
            passed = correct_count > total_questions - correct_count
        
        exam_duration = examiner.get_exam_duration()
        await asyncio.sleep(exam_duration)
        
        async with self.lock:
            examiner.total_students += 1
            if not passed:
                examiner.failed_students += 1
                student.status = StudentStatus.FAILED
            else:
                student.status = StudentStatus.PASSED
            
            student.finish_time = time.time() - self.start_time
            self.finished_students.append(student)
    
    async def examiner_work(self, examiner: Examiner):
        """Работа одного экзаменатора"""
        examiner.start_time = time.time()
        
        while True:
            # Проверка на возможность уйти на обед после 30 секунд
            current_time = time.time() - self.start_time
            async with self.lock:
                if (current_time > 30 and
                    examiner.current_student is None and
                    not examiner.is_on_lunch and
                    self.student_queue.qsize() > 0 and
                    len(self.finished_students) < len(self.students)):
                    examiner.is_on_lunch = True
                    lunch_duration = random.uniform(12, 18)
                    examiner.lunch_end_time = time.time() + lunch_duration
            
            if examiner.is_on_lunch:
                await asyncio.sleep(lunch_duration)
                async with self.lock:
                    examiner.is_on_lunch = False
                    examiner.lunch_end_time = None
                continue  # Продолжаем цикл после обеда
            
            try:
                student = await asyncio.wait_for(self.student_queue.get(), timeout=1.0)
                
                async with self.lock:
                    examiner.current_student = student
                
                await self.examine_student(examiner, student)
                
                async with self.lock:
                    examiner.current_student = None
                    examiner.work_time = time.time() - examiner.start_time  # Обновляем время работы
                
            except asyncio.TimeoutError:
                async with self.lock:
                    if len(self.finished_students) == len(self.students):
                        break
    
    def print_table_border_console(self, widths):
        """Печатает границу таблицы в консоль"""
        print("+" + "+".join(["-" * (w + 2) for w in widths]) + "+")
    
    def print_table_row_console(self, items, widths):
        """Печатает строку таблицы в консоль"""
        row = "|"
        for i, item in enumerate(items):
            row += f" {str(item):<{widths[i]}} |"
        print(row)
    
    def print_table_border(self, stdscr, y, x, widths):
        """Печатает границу таблицы в curses"""
        stdscr.addstr(y, x, "+" + "+".join(["-" * (w + 2) for w in widths]) + "+")
    
    def print_table_row(self, stdscr, y, x, items, widths):
        """Печатает строку таблицы в curses"""
        row = "|"
        for i, item in enumerate(items):
            row += f" {str(item):<{widths[i]}} |"
        stdscr.addstr(y, x, row)
    
    async def update_display(self, stdscr):
        """Асинхронное обновление дисплея"""
        while True:
            async with self.lock:
                if len(self.finished_students) >= len(self.students):
                    break
            
            stdscr.clear()
            
            current_time = time.time() - self.start_time if self.start_time else 0
            
            # Сортируем студентов по статусу
            queue_students = [s for s in self.students if s.status == StudentStatus.QUEUE]
            passed_students = [s for s in self.students if s.status == StudentStatus.PASSED]
            failed_students = [s for s in self.students if s.status == StudentStatus.FAILED]
            
            sorted_students = queue_students + passed_students + failed_students
            
            # Таблица студентов
            student_widths = [12, 10]  # Подогнано под пример
            y = 0
            self.print_table_border(stdscr, y, 0, student_widths)
            y += 1
            self.print_table_row(stdscr, y, 0, ["Студент", "Статус"], student_widths)
            y += 1
            self.print_table_border(stdscr, y, 0, student_widths)
            y += 1
            
            for student in sorted_students:
                self.print_table_row(stdscr, y, 0, [student.name, student.status.value], student_widths)
                y += 1
            
            self.print_table_border(stdscr, y, 0, student_widths)
            y += 2
            
            # Таблица экзаменаторов
            examiner_widths = [13, 17, 17, 9, 14]  # Подогнано под пример
            self.print_table_border(stdscr, y, 0, examiner_widths)
            y += 1
            self.print_table_row(stdscr, y, 0, ["Экзаменатор", "Текущий студент", "Всего студентов", "Завалил", "Время работы"], examiner_widths)
            y += 1
            self.print_table_border(stdscr, y, 0, examiner_widths)
            y += 1
            
            for examiner in self.examiners:
                current_student = examiner.current_student.name if examiner.current_student else "-"
                work_time_str = f"{examiner.work_time:.2f}" if not examiner.is_on_lunch else "-"  # Показываем - если на обеде
                self.print_table_row(stdscr, y, 0, [
                    examiner.name.split()[0],  # Только имя без пола
                    "-" if examiner.is_on_lunch else current_student,
                    str(examiner.total_students),
                    str(examiner.failed_students),
                    work_time_str
                ], examiner_widths)
                y += 1
            
            self.print_table_border(stdscr, y, 0, examiner_widths)
            y += 2
            
            remaining = len([s for s in self.students if s.status == StudentStatus.QUEUE])
            total = len(self.students)
            stdscr.addstr(y, 0, f"Осталось в очереди: {remaining} из {total}")
            y += 1
            stdscr.addstr(y, 0, f"Время с момента начала экзамена: {current_time:.2f}")
            
            stdscr.refresh()
            await asyncio.sleep(0.5)
        
    def display_final_console(self):
        total_time = time.time() - self.start_time
        
        passed_students = [s for s in self.students if s.status == StudentStatus.PASSED]
        failed_students = [s for s in self.students if s.status == StudentStatus.FAILED]
        
        # Таблица студентов
        student_widths = [12, 10]
        self.print_table_border_console(student_widths)
        self.print_table_row_console(["Студент", "Статус"], student_widths)
        self.print_table_border_console(student_widths)
        
        for student in passed_students + failed_students:
            self.print_table_row_console([student.name, student.status.value], student_widths)
        
        self.print_table_border_console(student_widths)
        print()
        
        # Таблица экзаменаторов
        examiner_widths = [13, 17, 9, 14]  # 4 столбца в финале
        self.print_table_border_console(examiner_widths)
        self.print_table_row_console(["Экзаменатор", "Всего студентов", "Завалил", "Время работы"], examiner_widths)
        self.print_table_border_console(examiner_widths)
        
        for examiner in self.examiners:
            self.print_table_row_console([
                examiner.name.split()[0],
                str(examiner.total_students),
                str(examiner.failed_students),
                f"{examiner.work_time:.2f}"
            ], examiner_widths)
        
        self.print_table_border_console(examiner_widths)
        print()
        
        print(f"Время с момента начала экзамена и до момента и его завершения: {total_time:.2f}")
        
        # Лучшие студенты (быстрее всех сдавшие)
        if passed_students:
            min_time = min((s.finish_time for s in passed_students if s.finish_time is not None), default=0)
            best_students = [s.name for s in passed_students if s.finish_time == min_time]
            print(f"Имена лучших студентов: {', '.join(best_students)}")
        
        # Лучшие экзаменаторы (с наименьшим процентом провалов)
        active_examiners = [e for e in self.examiners if e.total_students > 0]
        if active_examiners:
            min_fail_rate = min(e.failed_students / e.total_students if e.total_students > 0 else 0 for e in active_examiners)
            best_examiners = [e.name.split()[0] for e in active_examiners 
                              if (e.failed_students / e.total_students if e.total_students > 0 else 0) == min_fail_rate]
            print(f"Имена лучших экзаменаторов: {', '.join(best_examiners)}")
        
        # Студенты к отчислению (провалившиеся раньше других)
        if failed_students:
            min_fail_time = min((s.finish_time for s in failed_students if s.finish_time is not None), default=0)
            students_to_expel = [s.name for s in failed_students if s.finish_time == min_fail_time]
            print(f"Имена студентов, которых после экзамена отчислят: {', '.join(students_to_expel)}")
        
        # Лучшие вопросы
        if self.questions:
            max_correct = max(q.correct_answers_count for q in self.questions) if self.questions else 0
            best_questions = [q.text for q in self.questions if q.correct_answers_count == max_correct]
            print(f"Лучшие вопросы: {', '.join(best_questions)}")
        
        # Удался ли экзамен
        pass_rate = len(passed_students) / len(self.students) * 100 if self.students else 0
        exam_result = "удался" if pass_rate > 85 else "не удался"
        print(f"Вывод: экзамен {exam_result}")
    
    async def display_loop(self):
        """Цикл обновления отображения с использованием curses"""
        async def curses_async_wrapper():
            stdscr = curses.initscr()
            curses.noecho()
            curses.curs_set(0)
            
            try:
                await self.update_display(stdscr)
            finally:
                curses.endwin()
        
        await curses_async_wrapper()
    
    async def run_simulation(self):
        """Запускает симуляцию экзамена"""
        self.load_data()
        await self.fill_student_queue()
        
        self.start_time = time.time()
        
        examiner_tasks = [self.examiner_work(examiner) for examiner in self.examiners]
        display_task = self.display_loop()
        
        await asyncio.gather(*examiner_tasks, display_task)
        
        # Финальный вывод в консоль после завершения curses
        self.display_final_console()

async def main():
    simulation = ExamSimulation()
    await simulation.run_simulation()

if __name__ == "__main__":
    asyncio.run(main())