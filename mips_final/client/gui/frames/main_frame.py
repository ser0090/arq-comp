import PySimpleGUI as sg
from subprocess import check_output

_device_=''

main_tab_layout= [
                [sg.Text('Write program')],
                [sg.Input(),sg.FileBrowse(),sg.Submit('Write')]
             ]

fetch_tab_layout= [
                    [sg.Text('Fetch Stage Status:')],
                    [sg.Text('',size=(35,10),background_color='white',key='_FETCH_STAT_')],

                 ]

dec_tab_layout= [
                    [sg.Text('Decode Stage Status:')],
                    [sg.Text('',size=(35,10),background_color='white',key='_DECODE_STAT_')]
             ]

exec_tab_layout= [
                    [sg.Text('Execution Stage Status:')],
                    [sg.Text('',size=(35,10),background_color='white', key='_EXEC_STAT_')]
             ]

mem_tab_layout= [
                    [sg.Text('Memory Access Stage Status:')],
                    [sg.Text('',size=(35,10),background_color='white', key='_MEM_STAT_')],
                    [sg.Text('Data Memory content')],
                    [sg.Text('From: 0x'),sg.Input('00000000',size=(8,1),key='_FROM_ADDR_'),sg.Text('TO: 0x'),sg.Input('00000010',size=(8,1),key='_TO_ADDR_')],
                    [sg.Multiline('',size=(35,20),background_color='white',key='_MEM_DATA_',)]
]
layout = [  [sg.Text('Device: '.join(_device_))],
            [sg.Input('../bin',key='_BIN_FOLDER_')],
            [sg.TabGroup([
                        [
                            sg.Tab('Main'       , main_tab_layout , tooltip='tip'),
                            sg.Tab('Fetch'      , fetch_tab_layout, tooltip='tip'),
                            sg.Tab('Decode'     , dec_tab_layout  , tooltip='tip'),
                            sg.Tab('Execution'  , exec_tab_layout , tooltip='tip'),
                            sg.Tab('Memory'     , mem_tab_layout  , tooltip='tip'),

                        ]
                        ], tooltip='TIP2')],
            [sg.Button('Refresh'),sg.Button('Step'),sg.Exit()]
          ]




def _update_fetch(window,values):
    cmd = values['_BIN_FOLDER_'].strip().join('fetch ').join(_device_) #TODO: testear conectado al dispositivo
    stat = check_output(cmd, shell=True).strip()
    window.Element('_FETCH_STAT_').Update(stat)


def _update_decode(window,values):
    cmd = values['_BIN_FOLDER_'].strip().join('decode ').join(_device_) #TODO: testear conectado al dispositivo
    stat = check_output(cmd, shell=True).strip()
    window.Element('_DECODE_STAT_').Update(stat)

def _update_exec(window,values):
    cmd = values['_BIN_FOLDER_'].strip().join('exec ').join(_device_) #TODO: testear conectado al dispositivo
    stat = check_output(cmd, shell=True).strip()
    window.Element('_EXEC_STAT_').Update(stat)

def _update_mem(window,values):
    cmd = values['_BIN_FOLDER_'].strip().join('mem ').join(_device_) #TODO: testear conectado al dispositivo
    stat = check_output(cmd, shell=True).strip()
    window.Element('_MEM_STAT_').Update(stat)


def show():
    window = sg.Window('Window that stays open', layout)

    while True:
        event, values = window.Read()
        print(event, values)
        if event is event == 'Refresh':
            _update_fetch(window,values)
            _update_decode(window,values)
            _update_exec(window,values)
            _update_mem(window,values)


        if event is None or event == 'Exit':
            break


    window.Close()
