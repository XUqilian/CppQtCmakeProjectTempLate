#include "MainView.h"

MainView::MainView(QWidget *parent)
	: QMainWindow(parent), ui(new Ui::MainViewClass())
{
	ui->setupUi(this);
}

MainView::~MainView()
{
	delete ui;
}
