import matplotlib.pyplot as plt
import scipy.io

mat = scipy.io.loadmat('malt1_1.mat')

# Help menu
quit_help_str = "quit - \n    exit application\n\n"
help_help_str =  "help - \n    show options\n\n"
ls_help_str = "ls - \n    list all data sets available to plot\n\n"
plot_help_str = "plot [DEPENDENT DATA] [INDEPENDENT DATA] - \n    make plot of dependent vs independent data sets\n\n"
help_str = "Command list:\n\n" + ls_help_str + plot_help_str + quit_help_str + help_help_str
# print (help_str)

# while(1):
#     user_cmd = input('cmd: ')
#     cmd_array = user_cmd.split()
   
    # if (cmd_array[0] == "quit"):
    #     exit()

    # elif (cmd_array[0] == "help"):
    #         print (help_str)

    # elif(cmd_array[0] == 'ls'):
    #     for set in mat:
    #         print(set)

    # elif(cmd_array[0] == 'plot'):  
    #     try:  
    #         dependent = mat[cmd_array[1]]
    #         independent = mat[cmd_array[2]]

    #         plt.plot(independent, dependent)
    #         plt.title('Drone Speed')
    #         plt.xlabel('Time (s)')
    #         plt.ylabel('Speed (m/s)')
    #         plt.show()
    #     except Exception as e:
    #             print (e)
    #             print ('Invalid plot command')

# x position and z position auto plot (probably a vms or vms aux plot)

cmd_array = ["plot vms_aux0 vms_aux1" , 'plot aux_ins_gnd_spd_mps sys_frame_time_s', "quit"]

# Dynamically size the Figure into Subplots
Tot = len(cmd_array) - 1
Cols = int(Tot**0.5)

Rows = Tot // Cols

if Tot % Cols != 0:
    Rows += 1

Position = range(1,Tot + 1)

# Run through list to plot wanted data
for i in range(len(cmd_array)):

    cmd_split = cmd_array[i].split()

    if (cmd_split[0] == "quit"):
        plt.savefig('position.png')
        exit()

    elif (cmd_split[0] == "help"):
            print (help_str)

    elif(cmd_split[0] == 'ls'):
        for set in mat:
            print(set)

    elif(cmd_split[0] == 'plot'):  
        try:  
            dependent = mat[cmd_split[1]]
            independent = mat[cmd_split[2]]

            fig = plt.figure(1)

            ax = fig.add_subplot(Rows,Cols,Position[i])
            ax.plot(independent, dependent)
            ax.set_ylabel(cmd_split[2])
            ax.set_xlabel(cmd_split[1])

            fig.tight_layout(pad=1.0)

            # plt.plot(independent, dependent)
            # plt.title('Drone Position')
            # plt.xlabel('X Position (m)')
            # plt.ylabel('Z Position (m)')
            # plt.savefig('position.png')
        except Exception as e:
                print (e)
                print ('Invalid plot command')

