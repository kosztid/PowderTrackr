import SwiftUI

struct TrackListItem: View {
    enum Style {
        case normal
        case shared
    }

    let style: Style
    let dateFormatter: DateFormatter
    let formatter: DateComponentsFormatter
    var track: TrackedPath
    let notes = [
        "Note1 description something",
        "Note2 description something"
    ]
    let shareAction: (_ trackedPath: TrackedPath, _ userName: String) -> Void
    let closeAction: () -> Void
    let updateAction: (_ trackedPath: TrackedPath) -> Void
    let noteAction: (_ note: String, _ trackedPath: TrackedPath) -> Void
    let deleteAction: (_ trackedPath: TrackedPath) -> Void
    let totalDistance: Double
    let openedInitially: Bool
    var startDate: Date
    var endDate: Date
    var date: String
    @State var isOpened = false
    @State var note = ""
    @State var name = ""
    @State var isShowingOnMap = false
    @State private var showingAlert = false
    @State private var showingDeleteAlert = false
    @State private var showingRenameAlert = false

    var body: some View {
        VStack(spacing: .zero) {
            header
                .padding(.bottom, 8)
            if isOpened || openedInitially {
                openedSection
            }
        }
        .padding(8)
        .background(.white)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(.black, lineWidth: 1)
        )
        .padding(8)
    }

    var header: some View {
        HStack {
            Text(track.name)
            Spacer()
            VStack(alignment: .trailing) {
                Text("Date")
                    .font(.caption)
                Text(track.startDate)
            }
            if openedInitially {
                Button {
                    withAnimation {
                        closeAction()
                    }
                } label: {
                    Image(systemName: isOpened ? "xmark" : "arrowtriangle.down")
                        .foregroundColor(isOpened ? .white : .black)
                        .frame(width: 40, height: 40)
                        .rotationEffect(isOpened ? .degrees(180) : .zero)
                        .background(.teal)
                        .cornerRadius(20)
                }
            } else {
                Button {
                    withAnimation {
                        isOpened.toggle()
                    }
                } label: {
                    Image(systemName: isOpened ? "xmark" : "arrowtriangle.down")
                        .foregroundColor(isOpened ? .white : .black)
                        .frame(width: 40, height: 40)
                        .rotationEffect(isOpened ? .degrees(180) : .zero)
                        .background(.teal)
                        .cornerRadius(20)
                }
            }
        }
        .background()
        .alert("Rename run...", isPresented: $showingRenameAlert) {
            TextField("Enter the new name", text: $name)
                .autocorrectionDisabled(true)
            Button("Rename") {
                var newTrack = track
                newTrack.name = name
                updateAction(newTrack)
                name = ""
                showingRenameAlert.toggle()
            }
            Button(
                "Cancel",
                role: .cancel
            ) {
                name = ""
                showingRenameAlert.toggle()
            }
        }
        .alert("Add Note", isPresented: $showingAlert) {
            TextField("Enter note description", text: $note)
                .autocorrectionDisabled(true)
            Button("Add") {
                noteAction(note, track)
                note = ""
                showingAlert.toggle()
            }
            Button(
                "Cancel",
                role: .cancel
            ) {
                note = ""
                showingAlert.toggle()
            }
        }
        .alert("Are you sure to delete?", isPresented: $showingDeleteAlert) {
            Button(
                "Yes",
                role: .destructive
            ) {
                deleteAction(self.track)
                showingDeleteAlert.toggle()
            }
            Button(
                "Cancel",
                role: .cancel
            ) {
                showingDeleteAlert.toggle()
            }
        }
    }

    var openedSection: some View {
        VStack(spacing: .zero) {
            Divider()
                .padding(.vertical, 8)
            HStack {
                Text("Total distance moved:")
                Spacer()
                Text("\(totalDistance, specifier: "%.2f") meters")
            }
            .padding(.bottom, 4)
            HStack {
                Text("Duration:")
                Spacer()
                Text("\(date)")
            }
            .padding(.bottom, 8)
            HStack {
                Text("Show on Map")
                Spacer()
                Toggle(isOn: $isShowingOnMap) {
                }
            }
            if style == .normal {
                normalSection
            }
        }
        .onChange(of: isShowingOnMap) { newValue in
            var newTrack = track
            newTrack.tracking = newValue
            updateAction(newTrack)
        }
        .onAppear {
            print(track)
            self.isShowingOnMap = track.tracking
        }
    }

    var normalSection: some View {
        VStack(spacing: .zero) {
            Divider()
                .padding(.vertical, 8)
            if !openedInitially {
                notesSection
            }
            HStack {
                Button {
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
                .buttonStyle(SkiingButtonStyle(style: .secondary))
                .padding(.top, 8)
                Button {
                    name = track.name
                    showingRenameAlert.toggle()
                } label: {
                    Text("Rename run")
                        .frame(width: 95)
                }
                .buttonStyle(SkiingButtonStyle(style: .secondary))
                .padding(.top, 8)
                Button {
                    showingDeleteAlert.toggle()
                } label: {
                    Text("Delete run")
                        .frame(width: 95)
                }
                .buttonStyle(SkiingButtonStyle(style: .borderedRed))
                .padding(.top, 8)
            }
        }
    }
    var notesSection: some View {
        Group {
            HStack {
                Text("Notes")
                    .padding(.bottom, 8)
                Spacer()
                Button {
                    showingAlert.toggle()
                } label: {
                    Text("Add note")
                        .foregroundColor(.black)
                }
                .buttonStyle(SkiingButtonStyle(style: .bordered))
            }
            LazyVStack {
                ForEach(track.notes ?? [], id: \.self) { note in
                    HStack {
                        Text(note)
                        Spacer()
                    }
                }
            }
            Divider()
                .padding(.vertical, 8)
        }
    }

    init(
        track: TrackedPath,
        style: Style = .normal,
        shareAction: @escaping (_ trackedPath: TrackedPath, _ userName: String) -> Void = { _, _ in },
        closeAction: @escaping () -> Void = {},
        updateAction: @escaping (_ trackedPath: TrackedPath) -> Void = { _ in },
        noteAction: @escaping (_ note: String, _ trackedPath: TrackedPath) -> Void = { _, _ in },
        deleteAction: @escaping (_ trackedPath: TrackedPath) -> Void = { _ in },
        totalDistance: Double,
        isOpened: Bool = false,
        note: String = "",
        name: String = "",
        showingAlert: Bool = false,
        showingRenameAlert: Bool = false
    ) {
        self.track = track
        self.style = style
        self.shareAction = shareAction
        self.closeAction = closeAction
        self.updateAction = updateAction
        self.noteAction = noteAction
        self.deleteAction = deleteAction
        self.totalDistance = totalDistance
        self.openedInitially = isOpened
        self.startDate = Date()
        self.endDate = Date()
        self.date = ""
        self.dateFormatter = DateFormatter()
        self.formatter = DateComponentsFormatter()
        self.isOpened.toggle()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        self.note = note
        self.name = name
        self.showingAlert = showingAlert
        self.showingRenameAlert = showingRenameAlert
        self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.startDate = dateFormatter.date(from: track.startDate) ?? Date()
        self.endDate = dateFormatter.date(from: track.endDate) ?? Date()
        self.date = formatter.string(from: startDate.distance(to: endDate)) ?? ""
    }
}

struct TrackListItem_Previews: PreviewProvider {
    static var previews: some View {
        TrackListItem(
            track: .init(
                id: "ID123",
                name: "Path 123123",
                startDate: "2023-05-21 11:15:55",
                endDate: "2023-05-21 12:19:52",
                notes: ["Note1 description something", "Note2 description something"],
                tracking: true
            ),
            updateAction: { _ in
            }, noteAction: { _, _  in
            }, deleteAction: { _ in
            },
            totalDistance: 1000
        )
    }
}
